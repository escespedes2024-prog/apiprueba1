import 'package:mysql_client/mysql_client.dart';

class SeguimientoActividadSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final actRes = await connection.execute("SELECT id FROM actividades LIMIT 2");
    if (actRes.rows.isEmpty) return;
    final now = DateTime.now();
    final seguimientos = <Map<String, dynamic>>[];
    for (final row in actRes.rows) {
      seguimientos.add({
        'id_actividad': int.parse(row.colAt(0)!),
        'fecha_registro': now.toIso8601String().split('T').first,
        'estado': 'pendiente',
        'observacion': 'Registro inicial',
        'responsable': 'Coordinador',
        'porcentaje_avance': 10.0,
      });
    }

    for (final s in seguimientos) {
      await connection.execute('''
        INSERT INTO seguimiento_actividades (id_actividad, fecha_registro, estado, observacion, responsable, porcentaje_avance)
        SELECT :id_actividad, :fecha_registro, :estado, :observacion, :responsable, :porcentaje_avance
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM seguimiento_actividades WHERE id_actividad = :id_actividad AND fecha_registro = :fecha_registro)
      ''', s);
    }
    print('Seguimiento actividades creadas');
  }
}
