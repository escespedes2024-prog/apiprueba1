import 'package:mysql_client/mysql_client.dart';

import '../models/cargo.dart';
import 'service_crud.dart';

class ServiceCargo extends ServiceCrud {
  ServiceCargo(MySQLConnection connection) : super(connection, modeloCargo);
}
