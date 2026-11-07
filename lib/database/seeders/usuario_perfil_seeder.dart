import 'package:apiprueba1/database/seeders/user_profile_seeder.dart';
import 'package:mysql_client/mysql_client.dart';

class UsuarioPerfilSeeder {
  static Future<void> run(MySQLConnection connection) async {
    await UserProfileSeeder.run(connection);
  }
}
