import 'package:mysql_client/mysql_client.dart';

import '../models/culto.dart';
import 'service_crud.dart';

class ServiceCulto extends ServiceCrud {
  ServiceCulto(MySQLConnection connection) : super(connection, modeloCulto);
}
