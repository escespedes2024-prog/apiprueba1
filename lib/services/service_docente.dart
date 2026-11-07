import 'package:mysql_client/mysql_client.dart';

import '../models/docente.dart';
import 'service_crud.dart';

class ServiceDocente extends ServiceCrud {
  ServiceDocente(MySQLConnection connection) : super(connection, modeloDocente);
}
