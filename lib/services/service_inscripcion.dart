import 'package:mysql_client/mysql_client.dart';

import '../models/inscripcion.dart';
import 'service_crud.dart';

class ServiceInscripcion extends ServiceCrud {
  ServiceInscripcion(MySQLConnection connection) : super(connection, modeloInscripcion);
}
