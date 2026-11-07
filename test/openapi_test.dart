import 'dart:convert';

import 'package:apiprueba1/docs/openapi.dart';
import 'package:apiprueba1/docs/recursos_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';
import 'package:test/test.dart';

void main() {
  final documento = construirOpenApi();
  final paths = documento['paths'] as Map<String, dynamic>;
  final schemas =
      (documento['components'] as Map<String, dynamic>)['schemas']
          as Map<String, dynamic>;

  test('genera un documento OpenAPI 3.0', () {
    expect(documento['openapi'], '3.0.3');
    expect(documento['info'], isA<Map<String, dynamic>>());
    expect(paths, isNotEmpty);
    expect(schemas, isNotEmpty);
  });

  test('documenta el listado y el detalle de cada recurso', () {
    for (final recurso in recursosApi) {
      final base = '/api/${recurso.nombre}';
      final clave = recurso.modelo.tieneClaveCompuesta
          ? recurso.modelo.clavesPrimarias
                .map((columna) => '{$columna}')
                .join('/')
          : '{id}';

      expect(paths, contains(base));
      expect(paths, contains('$base/$clave'));
      expect(
        schemas,
        contains(_nombreSchema(recurso.nombre)),
        reason: 'Falta el esquema de ${recurso.nombre}',
      );
    }
  });

  test('no repite operationId ni parametros en una operacion', () {
    final operationIds = <String>{};

    for (final entrada in paths.entries) {
      final operaciones = entrada.value as Map<String, dynamic>;
      for (final operacion in operaciones.entries) {
        final datos = operacion.value as Map<String, dynamic>;
        final operationId = datos['operationId'] as String?;

        if (operationId != null) {
          expect(
            operationIds.add(operationId),
            isTrue,
            reason: 'operationId duplicado: $operationId',
          );
        }

        final parametros = (datos['parameters'] as List?) ?? const [];
        final nombres = <String>{};
        for (final parametro in parametros) {
          final nombre = (parametro as Map)['name'] as String;
          expect(
            nombres.add(nombre),
            isTrue,
            reason:
                'Parametro duplicado "$nombre" en '
                '${operacion.key} ${entrada.key}',
          );
        }
      }
    }
  });

  test('sirve Swagger UI en /docs y sus subrutas', () async {
    final router = Router();
    final swagger = SwaggerUI(
      jsonEncode(documento),
      specType: SpecType.json,
      title: 'API de prueba',
    );

    router.get('/docs', swagger.call);
    router.get('/docs/', swagger.call);
    router.get('/docs/<ruta|.*>', swagger.call);

    for (final ruta in ['/docs', '/docs/', '/docs/index.html']) {
      final respuesta = await router.call(
        Request('GET', Uri.parse('http://localhost$ruta')),
      );
      expect(respuesta.statusCode, 200, reason: 'Ruta $ruta');
      expect(
        await respuesta.readAsString(),
        contains('swagger-ui'),
        reason: 'Ruta $ruta',
      );
    }
  });
}

String _nombreSchema(String recurso) {
  final partes = recurso.split(RegExp(r'[-_]'));
  return partes
      .where((parte) => parte.isNotEmpty)
      .map((parte) => '${parte[0].toUpperCase()}${parte.substring(1)}')
      .join();
}
