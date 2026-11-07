import 'package:mysql_client/mysql_client.dart';

class ActividadSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final minRes = await connection.execute("SELECT id FROM ministerios ORDER BY id LIMIT 3");
    if (minRes.rows.isEmpty) {
      print('Actividades omitidas: no hay ministerios');
      return;
    }

    final idsMinisterio = [
      for (final row in minRes.rows) int.parse(row.colAt(0)!),
    ];
    final now = DateTime.now();
    final actividades = [
      {
        'id_ministerio': idsMinisterio[0],
        'nombre': 'Ensayo de Alabanza',
        'fecha': DateTime(now.year, now.month, now.day + 5).toIso8601String().split('T').first,
        'lugar': 'Salón Principal',
        'estado': 'planificada',
        'descripcion': 'Ensayo para domingo',
      },
      {
        'id_ministerio': idsMinisterio.length > 1 ? idsMinisterio[1] : idsMinisterio[0],
        'nombre': 'Reunión de Jóvenes',
        'fecha': DateTime(now.year, now.month, now.day + 3).toIso8601String().split('T').first,
        'lugar': 'Sala Juvenil',
        'estado': 'planificada',
        'descripcion': 'Estudio bíblico',
      },
    ];

    for (final a in actividades) {
      await connection.execute('''
        INSERT INTO actividades (id_ministerio, nombre, fecha, lugar, estado, descripcion)
        SELECT :id_ministerio, :nombre, :fecha, :lugar, :estado, :descripcion
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM actividades WHERE nombre = :nombre)
      ''', a);
    }
    print('Actividades creadas');
  }
}
