import 'package:mysql_client/mysql_client.dart';

class RegistraSeeder {
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
        INSERT INTO registra (id_miembro, id_sesion, estado, observacion)
        SELECT :id_miembro, :id_sesion, 'presente', 'registro'
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM registra WHERE id_miembro = :id_miembro AND id_sesion = :id_sesion)
      ''', {'id_miembro': idMiembro, 'id_sesion': idSesion});
    }
    print('Registra creados');
  }
}
