import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_token_acceso.dart';
import 'routes_crud.dart';

Router TokenAccesoRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceTokenAcceso(connection), 'tokens');
}
