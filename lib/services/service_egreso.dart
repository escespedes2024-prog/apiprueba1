import 'package:mysql_client/mysql_client.dart';

import '../models/egreso.dart';
import 'service_crud.dart';

class ServiceEgreso extends ServiceCrud {
  ServiceEgreso(MySQLConnection connection) : super(connection, modeloEgreso);
}
