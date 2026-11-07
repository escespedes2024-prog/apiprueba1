import 'package:mysql_client/mysql_client.dart';

class CultoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final cultos = [
      {'nombre': 'Culto Dominical', 'dia_semana': 'domingo', 'hora': '09:00:00', 'descripcion': 'Culto principal'},
      {'nombre': 'Oración de Miércoles', 'dia_semana': 'miercoles', 'hora': '19:00:00', 'descripcion': 'Reunión de oración'},
    ];
    for (final c in cultos) {
      await connection.execute('''
        INSERT INTO cultos (nombre, dia_semana, hora, descripcion)
        SELECT :nombre, :dia_semana, :hora, :descripcion
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM cultos WHERE nombre = :nombre)
      ''', c);
    }
    print('Cultos creados');
  }
}
