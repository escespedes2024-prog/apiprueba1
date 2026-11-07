import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_sesion.dart';
import 'routes_crud.dart';

Router SesionRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceSesion(connection), 'sesiones');
}
