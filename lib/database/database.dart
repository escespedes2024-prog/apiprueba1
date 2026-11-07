import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

class Database {
  static String get _host => (Platform.environment['DB_HOST'] ?? '127.0.0.1').trim();

  static int get _port =>
      int.tryParse((Platform.environment['DB_PORT'] ?? '').trim()) ?? 3306;

  static String get _user => (Platform.environment['DB_USER'] ?? 'root').trim();

  static String get _password => (Platform.environment['DB_PASSWORD'] ?? '').trim();

  static String get _database => (Platform.environment['DB_NAME'] ?? 'prueba1').trim();

  static Future<MySQLConnection> connet() async {
    final connection = await MySQLConnection.createConnection(
      host: _host,
      port: _port,
      userName: _user,
      password: _password,
      databaseName: _database,
    );
    await connection.connect();
    return connection;
  }
}
