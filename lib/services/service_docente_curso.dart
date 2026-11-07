import 'package:mysql_client/mysql_client.dart';

import '../models/docente_curso.dart';
import 'service_crud.dart';

class ServiceDocenteCurso extends ServiceCrud {
  ServiceDocenteCurso(MySQLConnection connection)
      : super(connection, modeloDocenteCurso);
}
