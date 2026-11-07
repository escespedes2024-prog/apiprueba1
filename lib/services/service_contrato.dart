import 'package:mysql_client/mysql_client.dart';

import '../models/contrato.dart';
import 'service_crud.dart';

class ServiceContrato extends ServiceCrud {
  ServiceContrato(MySQLConnection connection) : super(connection, modeloContrato);
}
