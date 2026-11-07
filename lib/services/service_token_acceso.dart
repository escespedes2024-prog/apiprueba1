import 'package:mysql_client/mysql_client.dart';

import '../models/token_acceso.dart';
import 'service_crud.dart';

class ServiceTokenAcceso extends ServiceCrud {
  ServiceTokenAcceso(MySQLConnection connection)
      : super(connection, modeloTokenAcceso);
}
