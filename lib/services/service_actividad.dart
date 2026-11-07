import 'package:mysql_client/mysql_client.dart';

import '../models/actividad.dart';
import 'service_crud.dart';

class ServiceActividad extends ServiceCrud {
  ServiceActividad(MySQLConnection connection) : super(connection, modeloActividad);
}
