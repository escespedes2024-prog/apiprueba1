import 'package:mysql_client/mysql_client.dart';

import '../models/miembro.dart';
import 'service_crud.dart';

class ServiceMiembro extends ServiceCrud {
  ServiceMiembro(MySQLConnection connection) : super(connection, modeloMiembro);
}
