import 'package:mysql_client/mysql_client.dart';

class AuditoriaSeeder {
  static Future<void> run(MySQLConnection connection) async {
    await runSimple(connection);
  }

  static Future<void> runSimple(MySQLConnection connection) async {
    final res = await connection.execute("SELECT COUNT(*) FROM auditorias");
    final count = int.tryParse(res.rows.first.colAt(0) ?? '0') ?? 0;
    if (count == 0) {
      await connection.execute(
        "INSERT INTO auditorias (created_at, updated_at) VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      );
    }
    print('Auditorías creadas');
  }
}
