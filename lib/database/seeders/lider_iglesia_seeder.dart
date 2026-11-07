import 'package:mysql_client/mysql_client.dart';

class LiderIglesiaSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final cargoRes = await connection.execute("SELECT id FROM cargos WHERE nombre = 'Lider de Ministerio' LIMIT 1");
    if (cargoRes.rows.isEmpty) return;
    final idCargo = int.parse(cargoRes.rows.first.colAt(0)!);
    final now = DateTime.now();
    final lideres = [
      {
        'id_cargo': idCargo,
        'nombre': 'Juan Pérez',
        'telefono': '78451236',
        'fecha_inicio': DateTime(now.year - 2, 1, 1).toIso8601String().split('T').first,
        'activo': 1,
      },
    ];
    for (final l in lideres) {
      await connection.execute('''
        INSERT INTO lideres_iglesia (id_cargo, nombre, telefono, fecha_inicio, activo)
        SELECT :id_cargo, :nombre, :telefono, :fecha_inicio, :activo
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM lideres_iglesia WHERE nombre = :nombre)
      ''', l);
    }
    print('Líderes de iglesia creados');
  }
}
