import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_seguimiento_actividad.dart';
import 'routes_crud.dart';

Router SeguimientoActividadRoutes(MySQLConnection connection) {
  return buildCrudRoutes(
    ServiceSeguimientoActividad(connection),
    'seguimientos',
  );
}
