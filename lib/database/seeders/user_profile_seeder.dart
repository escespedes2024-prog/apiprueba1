import 'package:mysql_client/mysql_client.dart';

class UserProfileSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final userRes = await connection.execute("SELECT id, email FROM users LIMIT 5");
    for (final row in userRes.rows) {
      final userId = int.parse(row.colAt(0)!);
      final email = row.colAt(1) ?? '';
      final username = email.split('@').first;
      await connection.execute('''
        INSERT INTO user_profiles (user_id, username, telefono, estado, fecha_registro)
        SELECT :user_id, :username, :telefono, 'activo', CURDATE()
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = :user_id)
      ''', {
        'user_id': userId,
        'username': username,
        'telefono': '70000000',
      });
    }
    print('Perfiles de usuario creados');
  }
}
