import 'package:mysql_client/mysql_client.dart';

import '../models/modelo.dart';

/// CRUD genérico para los modelos de la API.
///
/// Es "consciente del esquema": antes de construir cada consulta comprueba
/// qué columnas existen realmente en la base de datos. Así la API sigue
/// funcionando aunque la base de datos esté en una versión anterior o
/// posterior a la definida en los modelos (por ejemplo, mientras se aplican
/// las migraciones del proyecto Laravel). Las columnas que todavía no existen
/// simplemente se omiten; cuando se agreguen, aparecerán automáticamente.
class ServiceCrud {
  final MySQLConnection connection;
  final Modelo modelo;

  ServiceCrud(this.connection, this.modelo);

  /// Caché de columnas por tabla (compartida entre instancias/consultas).
  static final Map<String, Set<String>> _esquemaCache = {};

  /// Caché de claves primarias efectivas por tabla.
  static final Map<String, List<String>> _clavesCache = {};

  List<String> get columnas => modelo.columnas;

  Map<String, dynamic> _filaAMapa(ResultSetRow fila, List<String> nombres) {
    final mapa = <String, dynamic>{};
    for (var i = 0; i < nombres.length; i++) {
      mapa[nombres[i]] = fila.colAt(i);
    }
    return mapa;
  }

  List<Map<String, dynamic>> _mapaDesde(IResultSet resultado) {
    final nombres = resultado.cols.map((columna) => columna.name).toList();
    return resultado.rows.map((fila) => _filaAMapa(fila, nombres)).toList();
  }

  /// Columnas que existen de verdad en [tabla].
  Future<Set<String>> _columnasDe(String tabla) async {
    final cache = _esquemaCache[tabla];
    if (cache != null) return cache;

    final resultado = await connection.execute(
      'SELECT COLUMN_NAME FROM information_schema.COLUMNS '
      'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :tabla',
      {'tabla': tabla},
    );

    final columnas = resultado.rows
        .map((fila) => fila.colAt(0) ?? '')
        .where((columna) => columna.isNotEmpty)
        .toSet();

    _esquemaCache[tabla] = columnas;
    return columnas;
  }

  /// Claves primarias reales de la tabla. Si las claves declaradas en el
  /// modelo no existen (por ejemplo `cultos.id` frente a `cultos.id_culto`),
  /// se detecta la clave primaria real desde MySQL.
  Future<List<String>> _clavesEfectivas() async {
    final cache = _clavesCache[modelo.tabla];
    if (cache != null) return cache;

    final existentes = await _columnasDe(modelo.tabla);
    final configuradas =
        modelo.clavesPrimarias.where(existentes.contains).toList();

    if (configuradas.length == modelo.clavesPrimarias.length) {
      _clavesCache[modelo.tabla] = configuradas;
      return configuradas;
    }

    final resultado = await connection.execute(
      'SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE '
      "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :tabla "
      "AND CONSTRAINT_NAME = 'PRIMARY' ORDER BY ORDINAL_POSITION",
      {'tabla': modelo.tabla},
    );

    final reales = resultado.rows
        .map((fila) => fila.colAt(0) ?? '')
        .where((columna) => columna.isNotEmpty)
        .toList();

    final claves = reales.isNotEmpty ? reales : configuradas;
    _clavesCache[modelo.tabla] = claves;
    return claves;
  }

  List<String> _seleccion(Set<String> existentes, List<String> claves) {
    final seleccion = modelo.columnasPublicas
        .where((columna) => existentes.contains(columna))
        .toList();

    // La clave primaria real debe devolverse siempre, aunque el modelo declare
    // otro nombre (p. ej. `cultos.id_culto` frente a `cultos.id`). Sin ella el
    // cliente no puede identificar la fila para actualizarla o borrarla.
    for (final clave in claves) {
      if (existentes.contains(clave) && !seleccion.contains(clave)) {
        seleccion.add(clave);
      }
    }

    if (modelo.borradoLogico &&
        existentes.contains('deleted_at') &&
        !seleccion.contains('deleted_at')) {
      seleccion.add('deleted_at');
    }

    // Si el modelo no coincide con ninguna columna real, se devuelve todo
    // para no romper la consulta.
    return seleccion.isEmpty ? ['*'] : seleccion;
  }

  ({String where, Map<String, dynamic> params}) _condiciones({
    required Map<String, dynamic> filtros,
    required Set<String> existentes,
    String? busqueda,
    bool incluirEliminados = false,
  }) {
    final condiciones = <String>[];
    final parametros = <String, dynamic>{};

    if (modelo.borradoLogico &&
        !incluirEliminados &&
        existentes.contains('deleted_at')) {
      condiciones.add('${modelo.tabla}.deleted_at IS NULL');
    }

    for (final filtro in filtros.entries) {
      if (!modelo.esColumna(filtro.key)) continue;
      if (!existentes.contains(filtro.key)) continue;
      if (filtro.value == null) {
        condiciones.add('${filtro.key} IS NULL');
        continue;
      }
      final alias = 'f_${filtro.key}';
      condiciones.add('${filtro.key} = :$alias');
      parametros[alias] = filtro.value;
    }

    if (busqueda != null && busqueda.isNotEmpty && modelo.buscables.isNotEmpty) {
      final criterios = <String>[];
      for (var i = 0; i < modelo.buscables.length; i++) {
        final columna = modelo.buscables[i];
        if (!existentes.contains(columna)) continue;
        final alias = 'b$i';
        criterios.add('$columna LIKE :$alias');
        parametros[alias] = '%$busqueda%';
      }
      if (criterios.isNotEmpty) {
        condiciones.add('(${criterios.join(' OR ')})');
      }
    }

    return (
      where: condiciones.isEmpty ? '' : 'WHERE ${condiciones.join(' AND ')}',
      params: parametros,
    );
  }

  ({String where, Map<String, dynamic> params}) _whereDeClave(
    List<String> valores,
    List<String> claves,
  ) {
    final condiciones = <String>[];
    final parametros = <String, dynamic>{};
    for (var i = 0; i < claves.length && i < valores.length; i++) {
      condiciones.add('${claves[i]} = :pk$i');
      parametros['pk$i'] = valores[i];
    }
    return (
      where: 'WHERE ${condiciones.join(' AND ')}',
      params: parametros,
    );
  }

  Future<List<Map<String, dynamic>>> obtenerTodos({
    Map<String, dynamic> filtros = const {},
    String? busqueda,
    int pagina = 1,
    int porPagina = 25,
    String? ordenarPor,
    String direccion = 'asc',
    bool incluirEliminados = false,
  }) async {
    final existentes = await _columnasDe(modelo.tabla);
    final claves = await _clavesEfectivas();
    final seleccion = _seleccion(existentes, claves);

    final base = _condiciones(
      filtros: filtros,
      existentes: existentes,
      busqueda: busqueda,
      incluirEliminados: incluirEliminados,
    );

    final columnaOrden =
        ordenarPor != null &&
            modelo.esColumna(ordenarPor) &&
            existentes.contains(ordenarPor)
        ? ordenarPor
        : claves.first;
    final sentido = direccion.toLowerCase() == 'desc' ? 'DESC' : 'ASC';

    final parametros = <String, dynamic>{
      ...base.params,
      'limite': porPagina,
      'desplazamiento': (pagina - 1) * porPagina,
    };

    final resultado = await connection.execute('''
      SELECT ${seleccion.join(', ')}
      FROM ${modelo.tabla}
      ${base.where}
      ORDER BY $columnaOrden $sentido
      LIMIT :limite OFFSET :desplazamiento
    ''', parametros);

    final filas = _mapaDesde(resultado);
    if (modelo.relaciones.isEmpty) return filas;
    return _adjuntarRelaciones(filas);
  }

  Future<int> contar({
    Map<String, dynamic> filtros = const {},
    String? busqueda,
    bool incluirEliminados = false,
  }) async {
    final existentes = await _columnasDe(modelo.tabla);
    final base = _condiciones(
      filtros: filtros,
      existentes: existentes,
      busqueda: busqueda,
      incluirEliminados: incluirEliminados,
    );

    final resultado = await connection.execute('''
      SELECT COUNT(*) AS total
      FROM ${modelo.tabla}
      ${base.where}
    ''', base.params);

    if (resultado.rows.isEmpty) return 0;
    return int.tryParse(resultado.rows.first.colAt(0) ?? '0') ?? 0;
  }

  Future<Map<String, dynamic>?> obtenerPorId(List<String> valores) async {
    final existentes = await _columnasDe(modelo.tabla);
    final claves = await _clavesEfectivas();
    final seleccion = _seleccion(existentes, claves);
    final clave = _whereDeClave(valores, claves);

    final resultado = await connection.execute('''
      SELECT ${seleccion.join(', ')}
      FROM ${modelo.tabla}
      ${clave.where}
      LIMIT 1
    ''', clave.params);

    if (resultado.rows.isEmpty) return null;
    final filas = _mapaDesde(resultado);
    if (modelo.relaciones.isEmpty) return filas.first;
    final conRelaciones = await _adjuntarRelaciones(filas);
    return conRelaciones.first;
  }

  Future<Map<String, dynamic>?> crear(Map<String, dynamic> cuerpo) async {
    final existentes = await _columnasDe(modelo.tabla);
    final datos = <String, dynamic>{
      for (final entrada in modelo.sanear(cuerpo).entries)
        if (existentes.contains(entrada.key)) entrada.key: entrada.value,
    };
    if (datos.isEmpty) return null;

    final nombres = datos.keys.toList();
    final marcadores = <String>[];
    final parametros = <String, dynamic>{};
    for (var i = 0; i < nombres.length; i++) {
      marcadores.add(':v$i');
      parametros['v$i'] = datos[nombres[i]];
    }

    await connection.execute('''
      INSERT INTO ${modelo.tabla} (${nombres.join(', ')})
      VALUES (${marcadores.join(', ')})
    ''', parametros);

    if (modelo.tieneClaveCompuesta) {
      final claves = await _clavesEfectivas();
      final valores = <String>[];
      for (final clave in claves) {
        final valor = cuerpo[clave] ?? datos[clave];
        if (valor == null) return null;
        valores.add(valor.toString());
      }
      return obtenerPorId(valores);
    }

    final id = await _ultimoId();
    if (id == null) return null;
    return obtenerPorId([id]);
  }

  Future<Map<String, dynamic>?> actualizar(
    List<String> valores,
    Map<String, dynamic> cuerpo,
  ) async {
    final existentes = await _columnasDe(modelo.tabla);
    final datos = <String, dynamic>{
      for (final entrada in modelo.sanearParaActualizar(cuerpo).entries)
        if (existentes.contains(entrada.key)) entrada.key: entrada.value,
    };

    final claves = await _clavesEfectivas();
    final clave = _whereDeClave(valores, claves);
    final partes = <String>[];
    final parametros = <String, dynamic>{...clave.params};
    for (var i = 0; i < datos.length; i++) {
      final columna = datos.keys.elementAt(i);
      partes.add('$columna = :s$i');
      parametros['s$i'] = datos[columna];
    }

    if (partes.isEmpty) return obtenerPorId(valores);

    if (modelo.borradoLogico &&
        existentes.contains('deleted_at') &&
        !cuerpo.containsKey('deleted_at')) {
      partes.add('deleted_at = NULL');
    }

    await connection.execute('''
      UPDATE ${modelo.tabla}
      SET ${partes.join(', ')}
      ${clave.where}
    ''', parametros);

    return obtenerPorId(valores);
  }

  Future<bool> eliminar(List<String> valores) async {
    final existentes = await _columnasDe(modelo.tabla);
    final claves = await _clavesEfectivas();
    final clave = _whereDeClave(valores, claves);
    final parametros = <String, dynamic>{...clave.params};

    if (modelo.borradoLogico && existentes.contains('deleted_at')) {
      final resultado = await connection.execute('''
        UPDATE ${modelo.tabla}
        SET deleted_at = CURRENT_TIMESTAMP
        ${clave.where} AND deleted_at IS NULL
      ''', parametros);
      return resultado.affectedRows > BigInt.zero;
    }

    final resultado = await connection.execute(
      'DELETE FROM ${modelo.tabla} ${clave.where}',
      parametros,
    );
    return resultado.affectedRows > BigInt.zero;
  }

  Future<bool> restaurar(List<String> valores) async {
    if (!modelo.borradoLogico) return false;

    final existentes = await _columnasDe(modelo.tabla);
    if (!existentes.contains('deleted_at')) return false;

    final claves = await _clavesEfectivas();
    final clave = _whereDeClave(valores, claves);
    final resultado = await connection.execute('''
      UPDATE ${modelo.tabla}
      SET deleted_at = NULL
      ${clave.where}
    ''', clave.params);
    return resultado.affectedRows > BigInt.zero;
  }

  Future<String?> _ultimoId() async {
    final resultado = await connection.execute('SELECT LAST_INSERT_ID() AS id');
    if (resultado.rows.isEmpty) return null;
    return resultado.rows.first.colAt(0);
  }

  Future<List<Map<String, dynamic>>> _adjuntarRelaciones(
    List<Map<String, dynamic>> filas,
  ) async {
    if (filas.isEmpty) return filas;

    final columnasPrincipales = await _columnasDe(modelo.tabla);

    for (final relacion in modelo.relaciones) {
      // Si la clave foránea no existe en la tabla principal, la relación no
      // se puede resolver: se devuelve vacía en lugar de romper la consulta.
      if (!columnasPrincipales.contains(relacion.claveLocal)) {
        for (final fila in filas) {
          fila[relacion.alias] = relacion.esUna
              ? null
              : <Map<String, dynamic>>[];
        }
        continue;
      }

      final columnasRelacion = await _columnasDe(relacion.tabla);
      if (columnasRelacion.isEmpty ||
          !columnasRelacion.contains(relacion.claveRemota)) {
        for (final fila in filas) {
          fila[relacion.alias] = relacion.esUna
              ? null
              : <Map<String, dynamic>>[];
        }
        continue;
      }

      final columnasSeleccion = relacion.columnas
          .where(columnasRelacion.contains)
          .toList();
      if (columnasSeleccion.isEmpty) {
        columnasSeleccion.add(relacion.claveRemota);
      }

      final valores = filas
          .map((fila) => fila[relacion.claveLocal]?.toString())
          .whereType<String>()
          .where((valor) => valor.isNotEmpty)
          .toSet()
          .toList();

      final indexados = <String, List<Map<String, dynamic>>>{};

      if (valores.isNotEmpty) {
        final marcadores = List.generate(
          valores.length,
          (i) => ':r$i',
        ).join(', ');
        final parametros = <String, dynamic>{
          for (var i = 0; i < valores.length; i++) 'r$i': valores[i],
        };

        final borradoLogico =
            relacion.borradoLogico &&
            columnasRelacion.contains('deleted_at');

        final resultado = await connection.execute('''
          SELECT ${columnasSeleccion.join(', ')}, ${relacion.claveRemota} AS __clave
          FROM ${relacion.tabla}
          WHERE ${relacion.claveRemota} IN ($marcadores)
          ${borradoLogico ? 'AND deleted_at IS NULL' : ''}
        ''', parametros);

        for (final fila in _mapaDesde(resultado)) {
          final clave = fila['__clave']?.toString() ?? '';
          fila.remove('__clave');
          indexados.putIfAbsent(clave, () => []).add(fila);
        }
      }

      for (final fila in filas) {
        final clave = fila[relacion.claveLocal]?.toString();
        final encontrados = clave == null ? null : indexados[clave];
        fila[relacion.alias] = relacion.esUna
            ? (encontrados == null || encontrados.isEmpty
                  ? null
                  : encontrados.first)
            : (encontrados ?? <Map<String, dynamic>>[]);
      }
    }

    return filas;
  }
}
