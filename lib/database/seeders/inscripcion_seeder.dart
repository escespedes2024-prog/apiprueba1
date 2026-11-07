import 'package:mysql_client/mysql_client.dart';

class InscripcionSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final miembroRes = await connection.execute("SELECT id FROM miembros LIMIT 1");
    final cursoRes = await connection.execute("SELECT id FROM cursos LIMIT 1");
    if (miembroRes.rows.isEmpty || cursoRes.rows.isEmpty) return;
    final idMiembro = int.parse(miembroRes.rows.first.colAt(0)!);
    final idCurso = int.parse(cursoRes.rows.first.colAt(0)!);
    final now = DateTime.now();
    await connection.execute('''
      INSERT INTO inscripciones (miembro_id, curso_id, fecha_inscripcion, estado)
      SELECT :miembro_id, :curso_id, :fecha_inscripcion, 'Activo'
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM inscripciones WHERE miembro_id = :miembro_id AND curso_id = :curso_id)
    ''', {
      'miembro_id': idMiembro,
      'curso_id': idCurso,
      'fecha_inscripcion': now.toIso8601String().split('T').first,
    });
    print('Inscripciones creadas');
  }
}
