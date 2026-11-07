import 'package:mysql_client/mysql_client.dart';

import '../models/rol_usuario.dart';
import 'service_crud.dart';

class ServiceRolUsuario extends ServiceCrud {
  ServiceRolUsuario(MySQLConnection connection)
      : super(connection, modeloRolUsuario);
}
