import 'package:mysql_client/mysql_client.dart';

class CursoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    // Crear curso 1
    await connection.execute('''
      INSERT INTO cursos (nombre, f_inicio, f_fin, cupo_max, tiene_pago, monto_inscripcion)
      SELECT 'Doctrina Básica Cristiana', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 MONTH), 30, 0, 0.00
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM cursos WHERE nombre = 'Doctrina Básica Cristiana')
    ''');

    // Crear curso 2
    await connection.execute('''
      INSERT INTO cursos (nombre, f_inicio, f_fin, cupo_max, tiene_pago, monto_inscripcion)
      SELECT 'Liderazgo y Mentoreo Eficaz', DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 3 MONTH), 15, 1, 25.00
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM cursos WHERE nombre = 'Liderazgo y Mentoreo Eficaz')
    ''');

    // La vinculación docente-curso la realiza DocenteCursoSeeder.
    print('Cursos creados');
  }
}
