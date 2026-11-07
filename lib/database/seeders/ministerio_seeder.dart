import 'package:mysql_client/mysql_client.dart';

class MinisterioSeeder {
  static const _ministerios = [
    {
      'nombre': 'Alabanza y Adoración',
      'descripcion': 'Ministerio encargado de la música y dirección del canto en la congregación.',
    },
    {
      'nombre': 'Jóvenes con Propósito',
      'descripcion': 'Ministerio enfocado en el crecimiento espiritual de los jóvenes.',
    },
    {
      'nombre': 'Acción Social y Misiones',
      'descripcion': 'Ministerio de ayuda humanitaria y extensión comunitaria.',
    },
  ];

  static Future<void> run(MySQLConnection connection) async {
    final miembroRes = await connection.execute('''
      SELECT id FROM miembros ORDER BY id LIMIT ${_ministerios.length}
    ''');
    final idsLider = [
      for (final row in miembroRes.rows) int.parse(row.colAt(0)!),
    ];

    for (var i = 0; i < _ministerios.length; i++) {
      final idLider = i < idsLider.length ? idsLider[i] : null;
      final ministerio = _ministerios[i];
      await connection.execute('''
        INSERT INTO ministerios (nombre, descripcion, id_lider)
        SELECT :nombre, :descripcion, :id_lider
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM ministerios WHERE nombre = :nombre)
      ''', {...ministerio, 'id_lider': idLider});

      // Backfill para ministerios creados antes de asignar lider.
      if (idLider != null) {
        await connection.execute('''
          UPDATE ministerios SET id_lider = :id_lider
          WHERE nombre = :nombre AND id_lider IS NULL
        ''', {'id_lider': idLider, 'nombre': ministerio['nombre']});
      }
    }
    print('Ministerios creados');
  }
}
