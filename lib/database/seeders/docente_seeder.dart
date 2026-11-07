import 'package:mysql_client/mysql_client.dart';

class DocenteSeeder {
  static Future<void> run(MySQLConnection connection) async {
    // Se prefiere el miembro que usa Laravel para el docente; si no existe,
    // se toma el primer miembro disponible.
    final miembroRes = await connection.execute('''
      SELECT id FROM miembros
      ORDER BY (email = 'juan.perez@example.com') DESC, id
      LIMIT 1
    ''');
    if (miembroRes.rows.isEmpty) {
      print('Docentes omitidos: no hay miembros');
      return;
    }

    final docente = {
      'id_miembro': int.parse(miembroRes.rows.first.colAt(0)!),
      'especialidad': 'Teología Sistemática y Apologética',
      'titulo': 'Licenciado en Ciencias Bíblicas',
      'activo': 1,
    };

    await connection.execute('''
      INSERT INTO docentes (id_miembro, especialidad, titulo, activo)
      SELECT :id_miembro, :especialidad, :titulo, :activo
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM docentes WHERE id_miembro = :id_miembro)
    ''', docente);
    print('Docentes creados');
  }
}
