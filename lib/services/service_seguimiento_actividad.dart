import 'package:mysql_client/mysql_client.dart';

import '../models/seguimiento_actividad.dart';
import 'service_crud.dart';

class ServiceSeguimientoActividad extends ServiceCrud {
  ServiceSeguimientoActividad(MySQLConnection connection)
      : super(connection, modeloSeguimientoActividad);
}
