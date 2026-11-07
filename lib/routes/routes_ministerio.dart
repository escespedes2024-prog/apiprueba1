import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_ministerio.dart';
import 'routes_crud.dart';

Router MinisterioRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceMinisterio(connection), 'ministerios');
}
