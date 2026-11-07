import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_contrato.dart';
import 'routes_crud.dart';

Router ContratoRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceContrato(connection), 'contratos');
}
