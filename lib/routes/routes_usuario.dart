import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_usuario.dart';
import 'routes_crud.dart';

Router UsuarioRoutes(MySQLConnection connection) {
  final service = ServiceUsuario(connection);
  final router = buildCrudRoutes(service, 'usuarios');

  router.get('/api/usuarios/<id>/roles', (Request request) async {
    final id = int.tryParse(request.params['id'] ?? '');
    if (id == null) {
      return Response.badRequest(
        body: jsonEncode({'message': 'El id del usuario debe ser numerico'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
    try {
      final roles = await service.rolesDe(id);
      return Response.ok(
        jsonEncode({'data': roles}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': 'No se pudieron obtener los roles: $e'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  });

  return router;
}
