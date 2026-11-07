import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';
import 'package:dotenv/dotenv.dart';

import 'package:apiprueba1/database/database.dart';
import 'package:apiprueba1/docs/openapi.dart';
import 'package:apiprueba1/docs/recursos_api.dart';
import 'package:apiprueba1/routes/routes_actividad.dart';
import 'package:apiprueba1/routes/routes_asistencia_sesion.dart';
import 'package:apiprueba1/routes/routes_auditoria.dart';
import 'package:apiprueba1/routes/routes_cargo.dart';
import 'package:apiprueba1/routes/routes_contrato.dart';
import 'package:apiprueba1/routes/routes_curso.dart';
import 'package:apiprueba1/routes/routes_culto.dart';
import 'package:apiprueba1/routes/routes_docente.dart';
import 'package:apiprueba1/routes/routes_docente_curso.dart';
import 'package:apiprueba1/routes/routes_egreso.dart';
import 'package:apiprueba1/routes/routes_ingreso.dart';
import 'package:apiprueba1/routes/routes_inscripcion.dart';
import 'package:apiprueba1/routes/routes_lider_iglesia.dart';
import 'package:apiprueba1/routes/routes_miembro.dart';
import 'package:apiprueba1/routes/routes_miembro_ministerio.dart';
import 'package:apiprueba1/routes/routes_ministerio.dart';
import 'package:apiprueba1/routes/routes_pago_curso.dart';
import 'package:apiprueba1/routes/routes_perfil_usuario.dart';
import 'package:apiprueba1/routes/routes_registra.dart';
import 'package:apiprueba1/routes/routes_rol.dart';
import 'package:apiprueba1/routes/routes_rol_usuario.dart';
import 'package:apiprueba1/routes/routes_seguimiento_actividad.dart';
import 'package:apiprueba1/routes/routes_sesion.dart';
import 'package:apiprueba1/routes/routes_token_acceso.dart';
import 'package:apiprueba1/routes/routes_usuario.dart';

// Recursos expuestos por la API. Se derivan del registro central para que el
// indice `/api` y la documentacion OpenAPI se mantengan sincronizados.
final _recursos = <String, String>{
  for (final recurso in recursosApi) recurso.nombre: recurso.descripcion,
};

// Cabeceras CORS globales para permitir que la app Flutter web (y otras
// origenes) consuma la API desde el navegador.
const _corsHeaders = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Accept, Authorization',
  'Access-Control-Max-Age': '86400',
};

/// Middleware CORS: agrega las cabeceras a todas las respuestas y responde
/// 200 a los preflight OPTIONS (requerido por el navegador cuando la app
/// Flutter web corre en otro origen y llama a esta API).
Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await innerHandler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

Future<void> main(List<String> args) async {
  // Cargar variables de entorno desde .env
  final env = DotEnv()..load();

  final connection = await Database.connet();

  print(
    'Conectado a MySQL (base de datos: ${Platform.environment['DB_NAME'] ?? 'freedb_ukFLEtIO'}).',
  );

  final router = Router();

  router.get('/', (Request request) {
    return Response.ok(
      'API Dart conectada a la base de datos ${Platform.environment['DB_NAME'] ?? 'freedb_ukFLEtIO'}\n',
      headers: {'Content-Type': 'text/plain; charset=utf-8'},
    );
  });

  router.get('/api', (Request request) {
    return Response.ok(
      jsonEncode({
        'nombre': 'API Dart - iadministracion-cursos-biblicos',
        'base_datos': Platform.environment['DB_NAME'] ?? 'freedb_ukFLEtIO',
        'recursos': _recursos,
        'documentacion': '/docs',
        'openapi': '/api/openapi.json',
        'endpoints': {
          'listar': 'GET /api/{recurso}',
          'obtener': 'GET /api/{recurso}/{id}',
          'crear': 'POST /api/{recurso}',
          'actualizar': 'PUT /api/{recurso}/{id}',
          'eliminar': 'DELETE /api/{recurso}/{id}',
          'restaurar': 'POST /api/{recurso}/{id}/restaurar',
        },
      }),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
  });

  router.get('/api/salud', (Request request) async {
    try {
      final resultado = await connection.execute('SELECT 1 AS ok');
      final ok = resultado.rows.first.colAt(0) == '1';
      return Response.ok(
        jsonEncode({
          'estado': ok ? 'saludable' : 'degradado',
          'base_datos': Platform.environment['DB_NAME'] ?? 'freedb_ukFLEtIO',
          'hora': DateTime.now().toIso8601String(),
        }),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
    } catch (e) {
      return Response(
        503,
        body: jsonEncode({'estado': 'caido', 'error': '$e'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  });

  // Documento OpenAPI generado a partir de los modelos de la API.
  final documentoOpenApi = construirOpenApi();
  final documentoJson = jsonEncode(documentoOpenApi);

  router.get('/api/openapi.json', (Request request) {
    return Response.ok(
      documentoJson,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
  });

  final swagger = SwaggerUI(
    documentoJson,
    specType: SpecType.json,
    title: 'API - iadministracion-cursos-biblicos',
    docExpansion: DocExpansion.list,
    deepLink: true,
    persistAuthorization: true,
  );

  // Swagger UI en /docs (tambien acepta rutas internas como /docs/).
  router.get('/docs', swagger.call);
  router.get('/docs/', swagger.call);
  router.get('/docs/<ruta|.*>', swagger.call);

  final routers = <Router>[
    MiembroRoutes(connection),
    MinisterioRoutes(connection),
    DocenteRoutes(connection),
    DocenteCursoRoutes(connection),
    ActividadRoutes(connection),
    SeguimientoActividadRoutes(connection),
    CursoRoutes(connection),
    SesionRoutes(connection),
    ContratoRoutes(connection),
    CultoRoutes(connection),
    IngresoRoutes(connection),
    EgresoRoutes(connection),
    CargoRoutes(connection),
    LiderIglesiaRoutes(connection),
    InscripcionRoutes(connection),
    PagoCursoRoutes(connection),
    PerfilUsuarioRoutes(connection),
    AsistenciaSesionRoutes(connection),
    RegistraRoutes(connection),
    MiembroMinisterioRoutes(connection),
    UsuarioRoutes(connection),
    RolRoutes(connection),
    RolUsuarioRoutes(connection),
    TokenAccesoRoutes(connection),
    AuditoriaRoutes(connection),
  ];

  for (final subRouter in routers) {
    router.mount('/', subRouter.call);
  }

  router.all('/<path|.*>', (Request request) async {
    return Response.notFound(
      jsonEncode({'message': 'Ruta no encontrada: ${request.url.path}'}),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
  });

  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(corsMiddleware())
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await serve(handler, ip, port);

  print(
    'Servidor ejecutandose en http://${server.address.host}:${server.port}',
  );
  print(
    'Recursos disponibles en http://${server.address.host}:${server.port}/api',
  );
  print(
    'Documentacion Swagger en http://${server.address.host}:${server.port}/docs',
  );
}
