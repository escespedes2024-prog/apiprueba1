import 'package:mysql_client/mysql_client.dart';

class ContratoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final miembroRes = await connection.execute("SELECT id FROM miembros LIMIT 1");
    if (miembroRes.rows.isEmpty) return;
    final idMiembro = int.parse(miembroRes.rows.first.colAt(0)!);
    final now = DateTime.now();
    final contrato = {
      'id_miembro': idMiembro,
      'tipo_compensacion': 'Salario',
      'salario': 2000.0,
      'descripcion': 'Contrato de docente',
      'fecha_inicio': DateTime(now.year, 1, 1).toIso8601String().split('T').first,
      'fecha_fin': null,
      'activo': 1,
      'monto': 2000.0,
      'estado': 'activo',
    };
    await connection.execute('''
      INSERT INTO contratos (id_miembro, tipo_compensacion, salario, descripcion, fecha_inicio, fecha_fin, activo, monto, estado)
      SELECT :id_miembro, :tipo_compensacion, :salario, :descripcion, :fecha_inicio, :fecha_fin, :activo, :monto, :estado
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM contratos WHERE id_miembro = :id_miembro AND fecha_inicio = :fecha_inicio)
    ''', contrato);
    print('Contratos creados');
  }
}
