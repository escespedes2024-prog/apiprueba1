import 'package:mysql_client/mysql_client.dart';

import '../models/curso.dart';
import 'service_crud.dart';

class ServiceCurso extends ServiceCrud {
  ServiceCurso(MySQLConnection connection) : super(connection, modeloCurso);

  Future<List<Map<String, dynamic>>> docentesDe(int cursoId) async {
    final resultado = await connection.execute('''
      SELECT d.id, d.id_miembro, d.especialidad, d.titulo, d.activo
      FROM docentes d
      INNER JOIN docente_curso dc ON dc.id_docente = d.id
      WHERE dc.id_curso = :id_curso AND dc.deleted_at IS NULL
      ORDER BY d.id
    ''', {'id_curso': cursoId});

    final nombres = resultado.cols.map((columna) => columna.name).toList();
    return resultado.rows.map((fila) {
      final mapa = <String, dynamic>{};
      for (var i = 0; i < nombres.length; i++) {
        mapa[nombres[i]] = fila.colAt(i);
      }
      return mapa;
    }).toList();
  }
}
