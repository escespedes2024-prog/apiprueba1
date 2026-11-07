import 'dart:io';

import 'package:apiprueba1/database/database.dart';
import 'package:mysql_client/mysql_client.dart';

Future<void> main() async {
  print('Conectando a la base de datos...');

  MySQLConnection? connection;
  try {
    connection = await Database.connet();
    print('Conexion establecida.');

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS apiprueba1_migrations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        migration VARCHAR(255) NOT NULL UNIQUE,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    final scriptDir = Directory.fromUri(Platform.script.resolve('.'));
    final projectRoot = scriptDir.parent.path;
    final migrationsDirectory = Directory('$projectRoot/lib/database/migrations');

    if (!migrationsDirectory.existsSync()) {
      print('No se encontro el directorio ${migrationsDirectory.path}');
      return;
    }

    final files = migrationsDirectory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.sql'))
        .toList();

    files.sort((a, b) => a.path.compareTo(b.path));

    for (final file in files) {
      final migrationName = file.uri.pathSegments.last;

      final result = await connection.execute(
        'SELECT id FROM apiprueba1_migrations WHERE migration = :migration',
        {'migration': migrationName},
      );

      if (result.rows.isNotEmpty) {
        print('$migrationName ya ejecutada');
        continue;
      }

      final sql = await file.readAsString();

      await connection.execute(sql);

      await connection.execute(
        'INSERT INTO apiprueba1_migrations (migration) VALUES (:migration)',
        {'migration': migrationName},
      );

      print('$migrationName ejecutada');
    }

    print('\nMigraciones completadas.');
  } catch (e) {
    print('Error ejecutando migraciones: $e');
  } finally {
    await connection?.close();
  }
}
