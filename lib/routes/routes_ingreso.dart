import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_ingreso.dart';
import 'routes_crud.dart';

Router IngresoRoutes(MySQLConnection connection) {
  final service = ServiceIngreso(connection);
  final router = buildCrudRoutes(service, 'ingresos');

  router.get('/api/ingresos/resumen', (Request request) async {
    final query = request.url.queryParameters;
    try {
      final resumen = await service.resumenFinanciero(
        desde: DateTime.tryParse(query['desde'] ?? ''),
        hasta: DateTime.tryParse(query['hasta'] ?? ''),
      );
      return Response.ok(
        jsonEncode({'data': resumen}),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': 'No se pudo obtener el resumen: $e'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  });

  return router;
}
