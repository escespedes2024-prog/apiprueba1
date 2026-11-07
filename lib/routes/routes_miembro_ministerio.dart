import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_miembro_ministerio.dart';
import 'routes_crud.dart';

Router MiembroMinisterioRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceMiembroMinisterio(connection), 'miembros-ministerios');
}
