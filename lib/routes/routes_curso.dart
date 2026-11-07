import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_curso.dart';
import 'routes_crud.dart';

Router CursoRoutes(MySQLConnection connection) {
  final service = ServiceCurso(connection);
  final router = buildCrudRoutes(service, 'cursos');

  router.get('/api/cursos/<id>/docentes', (Request request) async {
    final id = int.tryParse(request.params['id'] ?? '');
    if (id == null) {
      return Response.badRequest(
        body: jsonEncode({'message': 'El id del curso debe ser numerico'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
    try {
      final docentes = await service.docentesDe(id);
      return Response.ok(
        jsonEncode({'data': docentes}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': 'No se pudieron obtener los docentes: $e'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  });

  return router;
}
