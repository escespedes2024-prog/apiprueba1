import 'package:mysql_client/mysql_client.dart';

import '../models/rol.dart';
import 'service_crud.dart';

class ServiceRol extends ServiceCrud {
  ServiceRol(MySQLConnection connection) : super(connection, modeloRol);
}
