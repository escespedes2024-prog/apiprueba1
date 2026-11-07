import '../models/modelo.dart';
import '../models/relacion.dart';
import 'recursos_api.dart';

/// Construye el documento OpenAPI 3.0.3 de la API a partir de los modelos.
///
/// Al generarse en tiempo de ejecucion, la documentacion se mantiene
/// sincronizada con las columnas, claves y relaciones declaradas en
/// `lib/models`.
Map<String, dynamic> construirOpenApi({String version = '1.0.0'}) {
  final paths = <String, dynamic>{
    '/api': _operacionIndice(),
    '/api/salud': _operacionSalud(),
  };

  final schemas = <String, dynamic>{
    'Error': _schemaError(),
    'Meta': _schemaMeta(),
  };

  final tags = <Map<String, dynamic>>[
    {
      'name': 'sistema',
      'description': 'Estado, indice y documentacion de la API',
    },
  ];

  for (final recurso in recursosApi) {
    final schema = _nombreSchema(recurso.nombre);
    schemas[schema] = _schemaModelo(recurso.modelo);
    schemas['${schema}Entrada'] = _schemaEntrada(recurso.modelo);
    tags.add({'name': recurso.nombre, 'description': recurso.descripcion});
    paths.addAll(_pathsRecurso(recurso, schema));
  }

  return {
    'openapi': '3.0.3',
    'info': {
      'title': 'API Dart - iadministracion-cursos-biblicos',
      'description':
          'API REST construida con Shelf para administrar los recursos de '
          'la base de datos MySQL del proyecto iadministracion-cursos-biblicos.',
      'version': version,
    },
    'servers': [
      {'url': '/', 'description': 'Servidor actual'},
    ],
    'tags': tags,
    'paths': paths,
    'components': {'schemas': schemas},
  };
}

Map<String, dynamic> _operacionIndice() {
  return {
    'get': {
      'tags': ['sistema'],
      'summary': 'Informacion general de la API',
      'description': 'Lista los recursos disponibles y las rutas del CRUD.',
      'operationId': 'obtenerIndiceApi',
      'responses': {
        '200': _respuestaJson('Recursos y endpoints disponibles', {
          'type': 'object',
          'properties': {
            'nombre': {'type': 'string'},
            'base_datos': {'type': 'string'},
            'recursos': {
              'type': 'object',
              'additionalProperties': {'type': 'string'},
            },
            'endpoints': {
              'type': 'object',
              'additionalProperties': {'type': 'string'},
            },
            'documentacion': {'type': 'string'},
            'openapi': {'type': 'string'},
          },
        }),
      },
    },
  };
}

Map<String, dynamic> _operacionSalud() {
  return {
    'get': {
      'tags': ['sistema'],
      'summary': 'Verifica la conexion con MySQL',
      'operationId': 'verificarSalud',
      'responses': {
        '200': _respuestaJson('API y base de datos saludables', {
          'type': 'object',
          'properties': {
            'estado': {
              'type': 'string',
              'enum': ['saludable', 'degradado'],
            },
            'base_datos': {'type': 'string'},
            'hora': {'type': 'string', 'format': 'date-time'},
          },
        }),
        '503': _respuestaJson('Base de datos no disponible', {
          'type': 'object',
          'properties': {
            'estado': {
              'type': 'string',
              'enum': ['caido'],
            },
            'error': {'type': 'string'},
          },
        }),
      },
    },
  };
}

Map<String, dynamic> _pathsRecurso(RecursoApi recurso, String schema) {
  final modelo = recurso.modelo;
  final base = '/api/${recurso.nombre}';
  final segmentoClave = modelo.tieneClaveCompuesta
      ? modelo.clavesPrimarias.map((clave) => '{$clave}').join('/')
      : '{id}';
  final ruta = '$base/$segmentoClave';
  final parametrosClave = _parametrosClave(modelo);

  final paths = <String, dynamic>{
    base: {
      'get': _operacionListar(recurso, schema),
      'post': _operacionCrear(recurso, schema),
    },
    ruta: {
      'get': _operacionObtener(recurso, schema, parametrosClave),
      'put': _operacionActualizar(recurso, schema, parametrosClave),
      'delete': _operacionEliminar(recurso, parametrosClave),
    },
  };

  if (modelo.borradoLogico) {
    paths['$ruta/restaurar'] = {
      'post': _operacionRestaurar(recurso, parametrosClave),
    };
  }

  return paths;
}

Map<String, dynamic> _operacionListar(RecursoApi recurso, String schema) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Lista ${recurso.nombre}',
    'description':
        'Devuelve ${recurso.descripcion.toLowerCase()} de forma paginada. '
        'Permite filtrar por cualquier columna publica del recurso.',
    'operationId': 'listar$schema',
    'parameters': [
      ..._parametrosFiltro(recurso.modelo),
      _parametroQuery(
        'pagina',
        'integer',
        'Numero de pagina (empieza en 1).',
        valorPorDefecto: 1,
        minimo: 1,
      ),
      _parametroQuery(
        'por_pagina',
        'integer',
        'Cantidad de registros por pagina.',
        valorPorDefecto: 25,
        minimo: 1,
      ),
      _parametroQuery(
        'buscar',
        'string',
        'Texto de busqueda libre sobre las columnas buscables del recurso.',
      ),
      _parametroQuery(
        'orden',
        'string',
        'Columna por la que se ordena el listado.',
      ),
      _parametroQuery(
        'direccion',
        'string',
        'Sentido del ordenamiento.',
        valorPorDefecto: 'asc',
        valores: ['asc', 'desc'],
      ),
      _parametroQuery(
        'incluir_eliminados',
        'string',
        'Usa 1 para incluir registros con borrado logico.',
        valores: ['0', '1'],
      ),
    ],
    'responses': {
      '200': _respuestaJson('Listado paginado', {
        'type': 'object',
        'properties': {
          'data': {'type': 'array', 'items': _ref(schema)},
          'meta': _ref('Meta'),
        },
        'required': ['data', 'meta'],
      }),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

Map<String, dynamic> _operacionCrear(RecursoApi recurso, String schema) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Crea un registro de ${recurso.nombre}',
    'operationId': 'crear$schema',
    'requestBody': _cuerpoJson('${schema}Entrada'),
    'responses': {
      '201': _respuestaJson('Registro creado', _envolturaDataMensaje(schema)),
      '400': _respuestaError('Cuerpo de la peticion invalido'),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

Map<String, dynamic> _operacionObtener(
  RecursoApi recurso,
  String schema,
  List<Map<String, dynamic>> parametrosClave,
) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Obtiene un registro de ${recurso.nombre}',
    'operationId': 'obtener$schema',
    'parameters': parametrosClave,
    'responses': {
      '200': _respuestaJson('Registro encontrado', _envolturaData(schema)),
      '404': _respuestaError('Registro no encontrado'),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

Map<String, dynamic> _operacionActualizar(
  RecursoApi recurso,
  String schema,
  List<Map<String, dynamic>> parametrosClave,
) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Actualiza un registro de ${recurso.nombre}',
    'operationId': 'actualizar$schema',
    'parameters': parametrosClave,
    'requestBody': _cuerpoJson('${schema}Entrada'),
    'responses': {
      '200': _respuestaJson(
        'Registro actualizado',
        _envolturaDataMensaje(schema),
      ),
      '400': _respuestaError('Cuerpo de la peticion invalido'),
      '404': _respuestaError('Registro no encontrado'),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

Map<String, dynamic> _operacionEliminar(
  RecursoApi recurso,
  List<Map<String, dynamic>> parametrosClave,
) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Elimina un registro de ${recurso.nombre}',
    'description': recurso.modelo.borradoLogico
        ? 'Aplica borrado logico: marca la columna deleted_at.'
        : 'Elimina el registro de forma permanente.',
    'operationId': 'eliminar${_nombreSchema(recurso.nombre)}',
    'parameters': parametrosClave,
    'responses': {
      '200': _respuestaMensaje('Registro eliminado'),
      '404': _respuestaError('Registro no encontrado'),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

Map<String, dynamic> _operacionRestaurar(
  RecursoApi recurso,
  List<Map<String, dynamic>> parametrosClave,
) {
  return {
    'tags': [recurso.nombre],
    'summary': 'Restaura un registro de ${recurso.nombre}',
    'description': 'Quita la marca de borrado logico (deleted_at = NULL).',
    'operationId': 'restaurar${_nombreSchema(recurso.nombre)}',
    'parameters': parametrosClave,
    'responses': {
      '200': _respuestaMensaje('Registro restaurado'),
      '404': _respuestaError('Registro no encontrado o sin borrado logico'),
      '500': _respuestaError('Error del servidor'),
    },
  };
}

List<Map<String, dynamic>> _parametrosClave(Modelo modelo) {
  if (!modelo.tieneClaveCompuesta) {
    return [
      {
        'name': 'id',
        'in': 'path',
        'required': true,
        'description':
            'Identificador del registro (columna ${modelo.clavesPrimarias.first}).',
        'schema': _schemaColumna(modelo.clavesPrimarias.first),
      },
    ];
  }

  return [
    for (final clave in modelo.clavesPrimarias)
      {
        'name': clave,
        'in': 'path',
        'required': true,
        'description': 'Parte de la clave primaria compuesta ($clave).',
        'schema': _schemaColumna(clave),
      },
  ];
}

const _parametrosReservados = {
  'pagina',
  'por_pagina',
  'buscar',
  'orden',
  'direccion',
  'incluir_eliminados',
};

List<Map<String, dynamic>> _parametrosFiltro(Modelo modelo) {
  return [
    for (final columna in modelo.columnasPublicas)
      if (!_parametrosReservados.contains(columna))
        {
          'name': columna,
          'in': 'query',
          'required': false,
          'description': 'Filtra por igualdad en la columna $columna.',
          'schema': _schemaColumna(columna),
        },
  ];
}

Map<String, dynamic> _parametroQuery(
  String nombre,
  String tipo,
  String descripcion, {
  Object? valorPorDefecto,
  int? minimo,
  List<String>? valores,
}) {
  final schema = <String, dynamic>{'type': tipo};
  if (valorPorDefecto != null) schema['default'] = valorPorDefecto;
  if (minimo != null) schema['minimum'] = minimo;
  if (valores != null) schema['enum'] = valores;

  return {
    'name': nombre,
    'in': 'query',
    'required': false,
    'description': descripcion,
    'schema': schema,
  };
}

Map<String, dynamic> _schemaModelo(Modelo modelo) {
  final propiedades = <String, dynamic>{
    for (final columna in modelo.columnasPublicas)
      columna: _propiedadColumna(columna, modelo),
  };

  for (final relacion in modelo.relaciones) {
    propiedades[relacion.alias] = _propiedadRelacion(relacion);
  }

  return {
    'type': 'object',
    'description': 'Registro de la tabla ${modelo.tabla}.',
    'properties': propiedades,
  };
}

Map<String, dynamic> _schemaEntrada(Modelo modelo) {
  final columnas = <String>[...modelo.columnasModificables];
  if (modelo.tieneClaveCompuesta) {
    for (final clave in modelo.clavesPrimarias) {
      if (!columnas.contains(clave)) columnas.add(clave);
    }
  }

  final propiedades = <String, dynamic>{};
  for (final columna in columnas) {
    if (Modelo.auditoria.contains(columna)) continue;
    propiedades[columna] = _schemaColumna(columna);
  }

  return {
    'type': 'object',
    'description':
        'Campos aceptados al crear o actualizar un registro de la tabla '
        '${modelo.tabla}.',
    'properties': propiedades,
    if (modelo.tieneClaveCompuesta) 'required': modelo.clavesPrimarias,
  };
}

Map<String, dynamic> _propiedadColumna(String columna, Modelo modelo) {
  final propiedad = _schemaColumna(columna);

  if (_esColumnaNula(columna)) propiedad['nullable'] = true;

  if (Modelo.auditoria.contains(columna)) {
    propiedad['readOnly'] = true;
  }

  if (!modelo.tieneClaveCompuesta &&
      columna == 'id' &&
      modelo.clavesPrimarias.contains(columna)) {
    propiedad['readOnly'] = true;
  }

  return propiedad;
}

Map<String, dynamic> _propiedadRelacion(Relacion relacion) {
  if (relacion.esUna) {
    return {
      'type': 'object',
      'nullable': true,
      'readOnly': true,
      'description': 'Relacion con la tabla ${relacion.tabla}.',
      'additionalProperties': true,
    };
  }

  return {
    'type': 'array',
    'readOnly': true,
    'description': 'Relacion con la tabla ${relacion.tabla}.',
    'items': {'type': 'object', 'additionalProperties': true},
  };
}

Map<String, dynamic> _schemaColumna(String columna) {
  final schema = <String, dynamic>{'type': _tipoColumna(columna)};
  final formato = _formatoColumna(columna);
  if (formato != null) schema['format'] = formato;
  return schema;
}

String _tipoColumna(String columna) {
  final nombre = columna.toLowerCase();

  if (nombre == 'id' ||
      nombre.startsWith('id_') ||
      nombre.endsWith('_id') ||
      nombre == 'registrado_por') {
    return 'integer';
  }

  if (nombre == 'activo' || nombre == 'tiene_pago') return 'boolean';

  if (const {
    'salario',
    'monto',
    'monto_total',
    'monto_inscripcion',
    'precio',
    'costo',
    'total',
  }.contains(nombre)) {
    return 'number';
  }

  if (const {
    'nivel_jerarquico',
    'nivel_acceso',
    'cupo_max',
    'porcentaje_avance',
  }.contains(nombre)) {
    return 'integer';
  }

  return 'string';
}

String? _formatoColumna(String columna) {
  final nombre = columna.toLowerCase();

  if (nombre == 'email') return 'email';
  if (nombre.endsWith('_at')) return 'date-time';
  if (nombre == 'fecha' ||
      nombre.startsWith('fecha_') ||
      nombre.endsWith('_fecha')) {
    return 'date';
  }
  if (nombre.startsWith('f_')) return 'date';

  return null;
}

bool _esColumnaNula(String columna) {
  return const {
    'deleted_at',
    'email_verified_at',
    'last_used_at',
    'expires_at',
    'fecha_fin',
    'f_fin',
  }.contains(columna);
}

String _nombreSchema(String recurso) {
  final partes = recurso.split(RegExp(r'[-_]'));
  return partes
      .where((parte) => parte.isNotEmpty)
      .map((parte) => '${parte[0].toUpperCase()}${parte.substring(1)}')
      .join();
}

Map<String, dynamic> _respuestaJson(
  String descripcion,
  Map<String, dynamic> schema,
) {
  return {
    'description': descripcion,
    'content': {
      'application/json': {'schema': schema},
    },
  };
}

Map<String, dynamic> _respuestaError(String descripcion) {
  return _respuestaJson(descripcion, _ref('Error'));
}

Map<String, dynamic> _respuestaMensaje(String descripcion) {
  return _respuestaJson(descripcion, {
    'type': 'object',
    'properties': {
      'message': {'type': 'string'},
    },
    'required': ['message'],
  });
}

Map<String, dynamic> _cuerpoJson(String schema) {
  return {
    'required': true,
    'content': {
      'application/json': {'schema': _ref(schema)},
    },
  };
}

Map<String, dynamic> _envolturaData(String schema) {
  return {
    'type': 'object',
    'properties': {'data': _ref(schema)},
    'required': ['data'],
  };
}

Map<String, dynamic> _envolturaDataMensaje(String schema) {
  return {
    'type': 'object',
    'properties': {
      'message': {'type': 'string'},
      'data': _ref(schema),
    },
  };
}

Map<String, dynamic> _ref(String schema) {
  return {r'$ref': '#/components/schemas/$schema'};
}

Map<String, dynamic> _schemaError() {
  return {
    'type': 'object',
    'properties': {
      'message': {'type': 'string', 'description': 'Descripcion del error.'},
    },
    'required': ['message'],
  };
}

Map<String, dynamic> _schemaMeta() {
  return {
    'type': 'object',
    'properties': {
      'pagina': {'type': 'integer'},
      'por_pagina': {'type': 'integer'},
      'total': {'type': 'integer'},
      'paginas': {'type': 'integer'},
    },
  };
}
