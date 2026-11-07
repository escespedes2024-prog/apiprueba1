import 'package:mysql_client/mysql_client.dart';

class MiembroMinisterioSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final miembroRes = await connection.execute("SELECT id FROM miembros ORDER BY id LIMIT 2");
    final ministerioRes = await connection.execute("SELECT id FROM ministerios ORDER BY id LIMIT 2");
    final cargoRes = await connection.execute("SELECT id FROM cargos WHERE nombre = 'Miembro' LIMIT 1");
    if (miembroRes.rows.isEmpty || ministerioRes.rows.isEmpty || cargoRes.rows.isEmpty) return;
    final idCargo = int.parse(cargoRes.rows.first.colAt(0)!);
    final ministerios = ministerioRes.rows.toList();
    int idx = 0;
    for (final mrow in miembroRes.rows) {
      if (idx >= ministerios.length) break;
      final idMiembro = int.parse(mrow.colAt(0)!);
      final idMinisterio = int.parse(ministerios[idx].colAt(0)!);
      idx++;
      await connection.execute('''
        INSERT INTO miembro_ministerio (miembro_id, ministerio_id, cargo_id, fecha_inicio)
        SELECT :miembro_id, :ministerio_id, :cargo_id, CURDATE()
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM miembro_ministerio WHERE miembro_id = :miembro_id AND ministerio_id = :ministerio_id)
      ''', {
        'miembro_id': idMiembro,
        'ministerio_id': idMinisterio,
        'cargo_id': idCargo,
      });
    }
    print('Miembro-Ministerio creados');
  }
}
