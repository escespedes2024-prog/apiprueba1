import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_docente.dart';
import 'routes_crud.dart';

Router DocenteRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceDocente(connection), 'docentes');
}
