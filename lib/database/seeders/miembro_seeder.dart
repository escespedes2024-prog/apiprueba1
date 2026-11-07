import 'package:mysql_client/mysql_client.dart';

class MiembroSeeder {
  static const _miembros = [
    {
      'nombre': 'Carlos Andres Rojas',
      'email': 'carlos.rojas@iglesia.test',
      'telefono': '70010001',
      'sexo': 'M',
      'direccion': 'Av. Central 123',
      'fecha_ingreso': '2024-01-15',
      'f_nacimiento': '1988-05-20',
    },
    {
      'nombre': 'Maria Fernanda Lopez',
      'email': 'maria.lopez@iglesia.test',
      'telefono': '70010002',
      'sexo': 'F',
      'direccion': 'Calle Norte 45',
      'fecha_ingreso': '2024-03-02',
      'f_nacimiento': '1992-11-08',
    },
    {
      'nombre': 'Joel Esteban Ramirez',
      'email': 'joel.ramirez@iglesia.test',
      'telefono': '70010003',
      'sexo': 'M',
      'direccion': 'Barrio Oriente 78',
      'fecha_ingreso': '2024-06-21',
      'f_nacimiento': '1995-02-14',
    },
  ];

  static Future<void> run(MySQLConnection connection) async {
    for (final miembro in _miembros) {
      await connection.execute('''
        INSERT INTO miembros
          (nombre, email, telefono, f_nacimiento, estado, direccion, fecha_ingreso, sexo)
        SELECT
          :nombre, :email, :telefono, :f_nacimiento, 'activo', :direccion, :fecha_ingreso, :sexo
        FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM miembros WHERE email = :email)
      ''', miembro);
    }
    print('Miembros creados');
  }
}
