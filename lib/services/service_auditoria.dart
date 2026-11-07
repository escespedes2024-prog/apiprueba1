import 'package:mysql_client/mysql_client.dart';

import '../models/auditoria.dart';
import 'service_crud.dart';

class ServiceAuditoria extends ServiceCrud {
  ServiceAuditoria(MySQLConnection connection) : super(connection, modeloAuditoria);
}
