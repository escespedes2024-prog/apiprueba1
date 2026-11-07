import 'package:mysql_client/mysql_client.dart';

class SesionSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final curso1Res = await connection.execute("SELECT id FROM cursos WHERE nombre = 'Doctrina Básica Cristiana' LIMIT 1");
    if (curso1Res.rows.isEmpty) return;
    final idCurso1 = int.parse(curso1Res.rows.first.colAt(0)!);

    final sesiones1 = [
      {'id_curso': idCurso1, 'tema': 'Introducción al Canon Bíblico', 'fecha': DateTime.now().add(Duration(days: 2)).toIso8601String().split('T').first, 'hora': '19:30:00', 'observacion': 'Traer cuaderno y biblia.'},
      {'id_curso': idCurso1, 'tema': 'La Naturaleza de Dios (Trinidad)', 'fecha': DateTime.now().add(Duration(days: 9)).toIso8601String().split('T').first, 'hora': '19:30:00', 'observacion': 'Lectura recomendada: Juan 1.'},
      {'id_curso': idCurso1, 'tema': 'La Caída del Hombre y la Gracia', 'fecha': DateTime.now().add(Duration(days: 16)).toIso8601String().split('T').first, 'hora': '19:30:00', 'observacion': 'Evaluación rápida del primer módulo.'},
    ];

    for (final s in sesiones1) {
      await connection.execute('''
        INSERT INTO sesiones (id_curso, tema, fecha, hora, observacion)
        SELECT :id_curso, :tema, :fecha, :hora, :observacion
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM sesiones WHERE id_curso = :id_curso AND tema = :tema)
      ''', s);
    }

    final curso2Res = await connection.execute("SELECT id FROM cursos WHERE nombre = 'Liderazgo y Mentoreo Eficaz' LIMIT 1");
    if (curso2Res.rows.isEmpty) return;
    final idCurso2 = int.parse(curso2Res.rows.first.colAt(0)!);

    final sesiones2 = [
      {'id_curso': idCurso2, 'tema': 'Cualidades del Carácter de un Líder', 'fecha': DateTime.now().add(Duration(days: 7)).toIso8601String().split('T').first, 'hora': '18:00:00', 'observacion': 'Estudio en el libro de Nehemías.'},
      {'id_curso': idCurso2, 'tema': 'El Arte de Escuchar y Aconsejar', 'fecha': DateTime.now().add(Duration(days: 14)).toIso8601String().split('T').first, 'hora': '18:00:00', 'observacion': 'Dinámicas de rol playing en clase.'},
      {'id_curso': idCurso2, 'tema': 'Planificación Estratégica Eclesial', 'fecha': DateTime.now().add(Duration(days: 21)).toIso8601String().split('T').first, 'hora': '18:00:00', 'observacion': 'Entrega de propuesta de proyecto final.'},
    ];

    for (final s in sesiones2) {
      await connection.execute('''
        INSERT INTO sesiones (id_curso, tema, fecha, hora, observacion)
        SELECT :id_curso, :tema, :fecha, :hora, :observacion
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM sesiones WHERE id_curso = :id_curso AND tema = :tema)
      ''', s);
    }

    print('Sesiones creadas');
  }
}
