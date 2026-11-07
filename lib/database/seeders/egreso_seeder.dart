import 'package:mysql_client/mysql_client.dart';

class EgresoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final now = DateTime.now();
    final egreso = {
      'tipo_egreso': 'materiales',
      'descripcion': 'Compra de insumos',
      'monto': 50.0,
      'fecha': now.toIso8601String().split('T').first,
      'responsable': 'Tesorero',
    };
    await connection.execute('''
      INSERT INTO egresos (tipo_egreso, descripcion, monto, fecha, responsable)
      SELECT :tipo_egreso, :descripcion, :monto, :fecha, :responsable
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM egresos WHERE fecha = :fecha AND monto = :monto AND descripcion = :descripcion)
    ''', egreso);
    print('Egresos creados');
  }
}
