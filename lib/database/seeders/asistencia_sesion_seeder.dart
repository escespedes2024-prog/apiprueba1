import 'package:mysql_client/mysql_client.dart';

class AsistenciaSesionSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final miembroRes = await connection.execute("SELECT id FROM miembros ORDER BY id LIMIT 2");
    final sesionRes = await connection.execute("SELECT id FROM sesiones ORDER BY id LIMIT 2");
    if (miembroRes.rows.isEmpty || sesionRes.rows.isEmpty) return;
    final sesiones = sesionRes.rows.toList();
    int idx = 0;
    for (final mrow in miembroRes.rows) {
      if (idx >= sesiones.length) break;
      final idMiembro = int.parse(mrow.colAt(0)!);
      final idSesion = int.parse(sesiones[idx].colAt(0)!);
      idx++;
      await connection.execute('''
        INSERT INTO asistencias_sesion (miembro_id, sesion_id, estado, observacion)
        SELECT :miembro_id, :sesion_id, 'presente', 'asistencia'
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM asistencias_sesion WHERE miembro_id = :miembro_id AND sesion_id = :sesion_id)
      ''', {'miembro_id': idMiembro, 'sesion_id': idSesion});
    }
    print('Asistencias de sesión creadas');
  }
}
