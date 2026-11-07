import 'package:mysql_client/mysql_client.dart';

class DocenteCursoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final docenteRes = await connection.execute("SELECT id FROM docentes LIMIT 1");
    final cursoRes = await connection.execute("SELECT id FROM cursos");
    if (docenteRes.rows.isEmpty || cursoRes.rows.isEmpty) return;
    final idDocente = int.parse(docenteRes.rows.first.colAt(0)!);
    for (final row in cursoRes.rows) {
      final idCurso = int.parse(row.colAt(0)!);
      await connection.execute('''
        INSERT INTO docente_curso (id_docente, id_curso)
        SELECT :id_docente, :id_curso
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM docente_curso WHERE id_docente = :id_docente AND id_curso = :id_curso)
      ''', {'id_docente': idDocente, 'id_curso': idCurso});
    }
    print('Docente-Curso creados');
  }
}
