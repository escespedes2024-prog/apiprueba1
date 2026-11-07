import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_rol.dart';
import 'routes_crud.dart';

Router RolRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceRol(connection), 'roles');
}
