import 'package:mysql_client/mysql_client.dart';

class IngresoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final now = DateTime.now();
    final ingreso = {
      'monto_total': 100.0,
      'fecha': now.toIso8601String().split('T').first,
      'tipo': 'ofrenda',
      'metodo_pago': 'efectivo',
    };
    await connection.execute('''
      INSERT INTO ingresos (monto_total, fecha, tipo, metodo_pago)
      SELECT :monto_total, :fecha, :tipo, :metodo_pago
      FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM ingresos WHERE fecha = :fecha AND monto_total = :monto_total)
    ''', ingreso);
    print('Ingresos creados');
  }
}
