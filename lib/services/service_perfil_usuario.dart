import 'package:mysql_client/mysql_client.dart';

import '../models/perfil_usuario.dart';
import 'service_crud.dart';

class ServicePerfilUsuario extends ServiceCrud {
  ServicePerfilUsuario(MySQLConnection connection)
      : super(connection, modeloPerfilUsuario);
}
