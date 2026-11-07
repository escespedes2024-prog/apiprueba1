import 'package:mysql_client/mysql_client.dart';

import '../models/pago_curso.dart';
import 'service_crud.dart';

class ServicePagoCurso extends ServiceCrud {
  ServicePagoCurso(MySQLConnection connection) : super(connection, modeloPagoCurso);
}
