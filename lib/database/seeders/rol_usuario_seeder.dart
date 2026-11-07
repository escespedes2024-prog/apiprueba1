import 'package:mysql_client/mysql_client.dart';

class RolUsuarioSeeder {
  static const _emailsAdmin = [
    'theanimeempire2024@gmail.com',
    'admin@iglesia.com',
  ];

  static Future<void> run(MySQLConnection connection) async {
    // Solo los administradores principales reciben rol Administrador,
    // igual que en DatabaseSeeder de Laravel.
    for (final email in _emailsAdmin) {
      await connection.execute('''
        INSERT INTO role_user (user_id, role_id, fecha_asignacion, estado)
        SELECT u.id, r.id, CURDATE(), 'activo'
        FROM users u
        JOIN roles r ON r.nombre = 'Administrador'
        WHERE u.email = :email
          AND NOT EXISTS (
            SELECT 1 FROM role_user ru WHERE ru.user_id = u.id AND ru.role_id = r.id
          )
      ''', {'email': email});
    }
    print('Roles de administrador asignados');
  }
}
