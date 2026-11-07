import 'package:mysql_client/mysql_client.dart';

class PagoCursoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final inscRes = await connection.execute("SELECT id FROM inscripciones LIMIT 1");
    if (inscRes.rows.isEmpty) return;
    final idInscripcion = int.parse(inscRes.rows.first.colAt(0)!);
    final now = DateTime.now();
    await connection.execute('''
      INSERT INTO pago_cursos (inscripcion_id, monto, fecha_pago, metodo_pago)
      SELECT :inscripcion_id, 25.00, :fecha_pago, 'efectivo'
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM pago_cursos WHERE inscripcion_id = :inscripcion_id)
    ''', {
      'inscripcion_id': idInscripcion,
      'fecha_pago': now.toIso8601String().split('T').first,
    });
    print('Pagos de curso creados');
  }
}
