import 'package:mysql_client/mysql_client.dart';

class UsuarioSeeder {
  static Future<void> run(MySQLConnection connection, {String? hashPassword}) async {
    // Crear usuario principal como en Laravel
    const emailMain = 'theanimeempire2024@gmail.com';
    final existeMain = await connection.execute(
      'SELECT COUNT(*) FROM users WHERE email = :email',
      {'email': emailMain},
    );
    final totalMain = int.tryParse(existeMain.rows.first.colAt(0) ?? '0') ?? 0;
    if (totalMain == 0 && hashPassword != null) {
      await connection.execute('''
        INSERT INTO users (name, email, password, email_verified_at, created_at, updated_at)
        VALUES (:name, :email, :password, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      ''', {
        'name': 'Administrador Principal',
        'email': emailMain,
        'password': hashPassword,
      });

      final idRes = await connection.execute('SELECT LAST_INSERT_ID() AS id');
      final usuarioId = int.parse(idRes.rows.first.colAt(0)!);

      await connection.execute('''
        INSERT INTO user_profiles (user_id, username, telefono, estado, fecha_registro)
        SELECT :user_id, 'admin_main', '71111111', 'activo', CURDATE()
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = :user_id)
      ''', {'user_id': usuarioId});

      await connection.execute('''
        INSERT INTO role_user (user_id, role_id, fecha_asignacion, estado)
        SELECT :user_id, r.id, CURRENT_DATE, 'activo'
        FROM roles r
        WHERE r.nombre = 'Administrador'
          AND NOT EXISTS (
            SELECT 1 FROM role_user WHERE user_id = :user_id AND role_id = r.id
          )
      ''', {'user_id': usuarioId});
    }

    // Crear usuario admin@iglesia.com
    const emailAdmin = 'admin@iglesia.com';
    final existeAdmin = await connection.execute(
      'SELECT COUNT(*) FROM users WHERE email = :email',
      {'email': emailAdmin},
    );
    final totalAdmin = int.tryParse(existeAdmin.rows.first.colAt(0) ?? '0') ?? 0;
    if (totalAdmin == 0 && hashPassword != null) {
      await connection.execute('''
        INSERT INTO users (name, email, password, email_verified_at, created_at, updated_at)
        VALUES (:name, :email, :password, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      ''', {
        'name': 'Administrador',
        'email': emailAdmin,
        'password': hashPassword,
      });

      final idRes = await connection.execute('SELECT LAST_INSERT_ID() AS id');
      final usuarioId = int.parse(idRes.rows.first.colAt(0)!);

      await connection.execute('''
        INSERT INTO user_profiles (user_id, username, telefono, estado, fecha_registro)
        SELECT :user_id, 'admin', '70000000', 'activo', CURDATE()
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = :user_id)
      ''', {'user_id': usuarioId});

      await connection.execute('''
        INSERT INTO role_user (user_id, role_id, fecha_asignacion, estado)
        SELECT :user_id, r.id, CURRENT_DATE, 'activo'
        FROM roles r
        WHERE r.nombre = 'Administrador'
          AND NOT EXISTS (
            SELECT 1 FROM role_user WHERE user_id = :user_id AND role_id = r.id
          )
      ''', {'user_id': usuarioId});
    }

    print('Usuarios creados');
  }
}
