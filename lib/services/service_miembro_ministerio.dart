import 'package:mysql_client/mysql_client.dart';

import '../models/miembro_ministerio.dart';
import 'service_crud.dart';

class ServiceMiembroMinisterio extends ServiceCrud {
  ServiceMiembroMinisterio(MySQLConnection connection)
      : super(connection, modeloMiembroMinisterio);
}
