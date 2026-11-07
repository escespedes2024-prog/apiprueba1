import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_perfil_usuario.dart';
import 'routes_crud.dart';

Router PerfilUsuarioRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServicePerfilUsuario(connection), 'perfiles-usuario');
}
