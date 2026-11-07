import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_auditoria.dart';
import 'routes_crud.dart';

Router AuditoriaRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceAuditoria(connection), 'auditorias');
}
