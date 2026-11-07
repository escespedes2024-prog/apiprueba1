import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_actividad.dart';
import 'routes_crud.dart';

Router ActividadRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceActividad(connection), 'actividades');
}
