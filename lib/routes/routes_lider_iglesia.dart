import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_lider_iglesia.dart';
import 'routes_crud.dart';

Router LiderIglesiaRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceLiderIglesia(connection), 'lideres-iglesia');
}
