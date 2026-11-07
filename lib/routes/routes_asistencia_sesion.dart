import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_asistencia_sesion.dart';
import 'routes_crud.dart';

Router AsistenciaSesionRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceAsistenciaSesion(connection), 'asistencias');
}
