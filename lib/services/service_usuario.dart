import 'package:mysql_client/mysql_client.dart';

import '../models/usuario.dart';
import 'service_crud.dart';

class ServiceUsuario extends ServiceCrud {
  ServiceUsuario(MySQLConnection connection) : super(connection, modeloUsuario);

  Future<List<Map<String, dynamic>>> rolesDe(int usuarioId) async {
    final resultado = await connection.execute('''
      SELECT r.id, r.nombre, r.descripcion, r.nivel_acceso, r.estado
      FROM roles r
      INNER JOIN role_user ru ON ru.role_id = r.id
      WHERE ru.user_id = :user_id AND ru.deleted_at IS NULL AND r.deleted_at IS NULL
      ORDER BY r.nivel_acceso DESC
    ''', {'user_id': usuarioId});

    final nombres = resultado.cols.map((columna) => columna.name).toList();
    return resultado.rows.map((fila) {
      final mapa = <String, dynamic>{};
      for (var i = 0; i < nombres.length; i++) {
        mapa[nombres[i]] = fila.colAt(i);
      }
      return mapa;
    }).toList();
  }

  Future<Map<String, dynamic>?> buscarPorEmail(String email) async {
    final resultado = await connection.execute('''
      SELECT id, name, email, password, created_at, updated_at
      FROM users
      WHERE email = :email
      LIMIT 1
    ''', {'email': email});

    if (resultado.rows.isEmpty) return null;
    final fila = resultado.rows.first;
    final mapa = <String, dynamic>{};
    for (var i = 0; i < resultado.numOfColumns; i++) {
      mapa[resultado.cols.elementAt(i).name] = fila.colAt(i);
    }
    return mapa;
  }
}
