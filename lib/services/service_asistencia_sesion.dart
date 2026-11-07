import 'package:mysql_client/mysql_client.dart';

import '../models/asistencia_sesion.dart';
import 'service_crud.dart';

class ServiceAsistenciaSesion extends ServiceCrud {
  ServiceAsistenciaSesion(MySQLConnection connection)
      : super(connection, modeloAsistenciaSesion);
}
