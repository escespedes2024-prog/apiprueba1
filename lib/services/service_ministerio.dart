import 'package:mysql_client/mysql_client.dart';

import '../models/ministerio.dart';
import 'service_crud.dart';

class ServiceMinisterio extends ServiceCrud {
  ServiceMinisterio(MySQLConnection connection) : super(connection, modeloMinisterio);
}
