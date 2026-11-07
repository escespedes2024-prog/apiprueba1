import 'package:mysql_client/mysql_client.dart';

import '../models/sesion.dart';
import 'service_crud.dart';

class ServiceSesion extends ServiceCrud {
  ServiceSesion(MySQLConnection connection) : super(connection, modeloSesion);
}
