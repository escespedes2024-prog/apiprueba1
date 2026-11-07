import 'package:mysql_client/mysql_client.dart';

import '../models/lider_iglesia.dart';
import 'service_crud.dart';

class ServiceLiderIglesia extends ServiceCrud {
  ServiceLiderIglesia(MySQLConnection connection)
      : super(connection, modeloLiderIglesia);
}
