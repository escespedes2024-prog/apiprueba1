import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';

import '../services/service_inscripcion.dart';
import 'routes_crud.dart';

Router InscripcionRoutes(MySQLConnection connection) {
  return buildCrudRoutes(ServiceInscripcion(connection), 'inscripciones');
}
