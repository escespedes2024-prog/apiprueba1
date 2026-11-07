import 'package:mysql_client/mysql_client.dart';

class RolSeeder {
  static const _roles = [
    {'nombre': 'Administrador', 'descripcion': 'Acceso total al sistema', 'nivel_acceso': 1},
    {'nombre': 'Pastor', 'descripcion': 'Vision general de la iglesia', 'nivel_acceso': 2},
    {'nombre': 'Secretario', 'descripcion': 'Gestión de miembros y actividades', 'nivel_acceso': 3},
    {'nombre': 'Tesorero', 'descripcion': 'Gestión financiera', 'nivel_acceso': 4},
    {'nombre': 'Lider', 'descripcion': 'Lidera un ministerio especifico', 'nivel_acceso': 5},
    {'nombre': 'Docente', 'descripcion': 'Imparte clases de los cursos', 'nivel_acceso': 6},
    {'nombre': 'Miembro', 'descripcion': 'Acceso basico a la plataforma', 'nivel_acceso': 7},
  ];

  static Future<void> run(MySQLConnection connection) async {
    for (final rol in _roles) {
      await connection.execute('''
        INSERT INTO roles (nombre, descripcion, nivel_acceso, estado, guard_name)
        SELECT :nombre, :descripcion, :nivel_acceso, 'activo', 'web'
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM roles WHERE nombre = :nombre)
      ''', rol);
    }
    print('Roles creados');
  }
}
