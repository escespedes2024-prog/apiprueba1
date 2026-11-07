import 'package:mysql_client/mysql_client.dart';

import '../models/modelo.dart';

class ServiceCrud {
  final MySQLConnection connection;
  final Modelo modelo;

  ServiceCrud(this.connection, this.modelo);

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

  List<String> _seleccion() {
    final seleccion = modelo.columnasPublicas;
    if (!modelo.borradoLogico) return seleccion;
    return [...seleccion, 'deleted_at'];
  }

  ({String where, Map<String, dynamic> params}) _condiciones({
    required Map<String, dynamic> filtros,
    String? busqueda,
    bool incluirEliminados = false,
  }) {
    final condiciones = <String>[];
    final parametros = <String, dynamic>{};

    if (modelo.borradoLogico && !incluirEliminados) {
      condiciones.add('${modelo.tabla}.deleted_at IS NULL');
    }

    for (final filtro in filtros.entries) {
      if (!modelo.esColumna(filtro.key)) continue;
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
        final alias = 'b$i';
        criterios.add('${modelo.buscables[i]} LIKE :$alias');
        parametros[alias] = '%$busqueda%';
      }
      condiciones.add('(${criterios.join(' OR ')})');
    }

    return (
      where: condiciones.isEmpty ? '' : 'WHERE ${condiciones.join(' AND ')}',
      params: parametros,
    );
  }

  ({String where, Map<String, dynamic> params}) _whereDeClave(List<String> valores) {
    final condiciones = <String>[];
    final parametros = <String, dynamic>{};
    for (var i = 0; i < modelo.clavesPrimarias.length; i++) {
      condiciones.add('${modelo.clavesPrimarias[i]} = :pk$i');
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
    final base = _condiciones(
      filtros: filtros,
      busqueda: busqueda,
      incluirEliminados: incluirEliminados,
    );

    final columnaOrden = ordenarPor != null && modelo.esColumna(ordenarPor)
        ? ordenarPor
        : modelo.clavesPrimarias.first;
    final sentido = direccion.toLowerCase() == 'desc' ? 'DESC' : 'ASC';

    final parametros = <String, dynamic>{
      ...base.params,
      'limite': porPagina,
      'desplazamiento': (pagina - 1) * porPagina,
    };

    final resultado = await connection.execute('''
      SELECT ${_seleccion().join(', ')}
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
    final base = _condiciones(
      filtros: filtros,
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
    final clave = _whereDeClave(valores);

    final resultado = await connection.execute('''
      SELECT ${_seleccion().join(', ')}
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
    final datos = modelo.sanear(cuerpo);
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
      return obtenerPorId(
        modelo.clavesPrimarias
            .map((clave) => (cuerpo[clave] ?? datos[clave]).toString())
            .toList(),
      );
    }

    final id = await _ultimoId();
    if (id == null) return null;
    return obtenerPorId([id]);
  }

  Future<Map<String, dynamic>?> actualizar(
    List<String> valores,
    Map<String, dynamic> cuerpo,
  ) async {
    final datos = modelo.sanearParaActualizar(cuerpo);

    final clave = _whereDeClave(valores);
    final partes = <String>[];
    final parametros = <String, dynamic>{...clave.params};
    for (var i = 0; i < datos.length; i++) {
      final columna = datos.keys.elementAt(i);
      partes.add('$columna = :s$i');
      parametros['s$i'] = datos[columna];
    }

    if (partes.isEmpty) return obtenerPorId(valores);

    if (modelo.borradoLogico && !cuerpo.containsKey('deleted_at')) {
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
    final clave = _whereDeClave(valores);
    final parametros = <String, dynamic>{...clave.params};

    if (modelo.borradoLogico) {
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

    final clave = _whereDeClave(valores);
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

    for (final relacion in modelo.relaciones) {
      final valores = filas
          .map((fila) => fila[relacion.claveLocal]?.toString())
          .whereType<String>()
          .where((valor) => valor.isNotEmpty)
          .toSet()
          .toList();

      final indexados = <String, List<Map<String, dynamic>>>{};

      if (valores.isNotEmpty) {
        final marcadores = List.generate(valores.length, (i) => ':r$i').join(', ');
        final parametros = <String, dynamic>{
          for (var i = 0; i < valores.length; i++) 'r$i': valores[i],
        };

        final resultado = await connection.execute('''
          SELECT ${relacion.columnas.join(', ')}, ${relacion.claveRemota} AS __clave
          FROM ${relacion.tabla}
          WHERE ${relacion.claveRemota} IN ($marcadores)
          ${relacion.borradoLogico ? 'AND deleted_at IS NULL' : ''}
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
            ? (encontrados == null || encontrados.isEmpty ? null : encontrados.first)
            : (encontrados ?? <Map<String, dynamic>>[]);
      }
    }

    return filas;
  }
}
