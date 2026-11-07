import 'package:mysql_client/mysql_client.dart';

class CargoSeeder {
  static const _cargos = [
    {'nombre': 'Pastor Principal', 'descripcion': 'Maxima autoridad de la iglesia', 'nivel_jerarquico': 1},
    {'nombre': 'Co-Pastor', 'descripcion': 'Segunda autoridad eclesiastica', 'nivel_jerarquico': 2},
    {'nombre': 'Lider de Ministerio', 'descripcion': 'Encargado de un ministerio', 'nivel_jerarquico': 3},
    {'nombre': 'Tesorero', 'descripcion': 'Administra los recursos financieros', 'nivel_jerarquico': 4},
    {'nombre': 'Secretario', 'descripcion': 'Registro y documentacion', 'nivel_jerarquico': 5},
    {'nombre': 'Diacono', 'descripcion': 'Servicio y apoyo logistico', 'nivel_jerarquico': 6},
    {'nombre': 'Miembro', 'descripcion': 'Participacion general', 'nivel_jerarquico': 7},
  ];

  static Future<void> run(MySQLConnection connection) async {
    for (final cargo in _cargos) {
      await connection.execute('''
        INSERT INTO cargos (nombre, descripcion, nivel_jerarquico)
        SELECT :nombre, :descripcion, :nivel_jerarquico
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM cargos WHERE nombre = :nombre)
      ''', cargo);
    }
    print('Cargos creados');
  }
}
