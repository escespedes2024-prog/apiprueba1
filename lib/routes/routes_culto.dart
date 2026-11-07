import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_culto.dart';
import 'routes_crud.dart';

Router CultoRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceCulto(connection), 'cultos');
}
