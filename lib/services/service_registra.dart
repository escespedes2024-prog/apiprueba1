import 'package:mysql_client/mysql_client.dart';

import '../models/registra.dart';
import 'service_crud.dart';

class ServiceRegistra extends ServiceCrud {
  ServiceRegistra(MySQLConnection connection) : super(connection, modeloRegistra);
}
