import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_registra.dart';
import 'routes_crud.dart';

Router RegistraRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceRegistra(connection), 'registros');
}
