import 'package:apiprueba1/database/database.dart';
import 'package:apiprueba1/database/seeders/actividad_seeder.dart';
import 'package:apiprueba1/database/seeders/asistencia_sesion_seeder.dart';
import 'package:apiprueba1/database/seeders/auditoria_seeder.dart';
import 'package:apiprueba1/database/seeders/cargo_seeder.dart';
import 'package:apiprueba1/database/seeders/contrato_seeder.dart';
import 'package:apiprueba1/database/seeders/culto_seeder.dart';
import 'package:apiprueba1/database/seeders/curso_seeder.dart';
import 'package:apiprueba1/database/seeders/docente_curso_seeder.dart';
import 'package:apiprueba1/database/seeders/docente_seeder.dart';
import 'package:apiprueba1/database/seeders/egreso_seeder.dart';
import 'package:apiprueba1/database/seeders/ingreso_seeder.dart';
import 'package:apiprueba1/database/seeders/inscripcion_seeder.dart';
import 'package:apiprueba1/database/seeders/lider_iglesia_seeder.dart';
import 'package:apiprueba1/database/seeders/miembro_ministerio_seeder.dart';
import 'package:apiprueba1/database/seeders/miembro_seeder.dart';
import 'package:apiprueba1/database/seeders/ministerio_seeder.dart';
import 'package:apiprueba1/database/seeders/pago_curso_seeder.dart';
import 'package:apiprueba1/database/seeders/personal_access_token_seeder.dart';
import 'package:apiprueba1/database/seeders/registra_seeder.dart';
import 'package:apiprueba1/database/seeders/rol_seeder.dart';
import 'package:apiprueba1/database/seeders/rol_usuario_seeder.dart';
import 'package:apiprueba1/database/seeders/seguimiento_actividad_seeder.dart';
import 'package:apiprueba1/database/seeders/sesion_seeder.dart';
import 'package:apiprueba1/database/seeders/user_profile_seeder.dart';
import 'package:apiprueba1/database/seeders/usuario_seeder.dart';
import 'package:mysql_client/mysql_client.dart';

Future<void> main(List<String> args) async {
  print('Iniciando seeders...');

  try {
    final connection = await Database.connet();
    try {
      final seederName = _getSeederName(args);
      final hashPassword = _getPasswordHash(args);
      if (seederName != null) {
        await _runSpecific(connection, seederName, hashPassword);
      } else {
        await _runAll(connection, hashPassword);
      }
      print('Seeders ejecutados correctamente.');
    } finally {
      await connection.close();
    }
  } catch (e) {
    print('Error ejecutando seeders: $e');
  }
}

String? _getSeederName(List<String> args) {
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith('--seeder=')) {
      return args[i].split('=')[1];
    }
    if (args[i] == '--seeder' && i + 1 < args.length) {
      return args[i + 1];
    }
  }
  return null;
}

String? _getPasswordHash(List<String> args) {
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith('--password-hash=')) {
      return args[i].split('=')[1];
    }
    if ((args[i] == '--password-hash' || args[i] == '-p') && i + 1 < args.length) {
      return args[i + 1];
    }
  }
  return null;
}

Future<void> _runAll(MySQLConnection connection, String? passwordHash) async {
  await RolSeeder.run(connection);
  await UsuarioSeeder.run(connection, hashPassword: passwordHash);
  await CargoSeeder.run(connection);
  await MiembroSeeder.run(connection);
  await MinisterioSeeder.run(connection);
  await DocenteSeeder.run(connection);
  await CursoSeeder.run(connection);
  await SesionSeeder.run(connection);
  await DocenteCursoSeeder.run(connection);
  await ActividadSeeder.run(connection);
  await SeguimientoActividadSeeder.run(connection);
  await LiderIglesiaSeeder.run(connection);
  await ContratoSeeder.run(connection);
  await CultoSeeder.run(connection);
  await InscripcionSeeder.run(connection);
  await PagoCursoSeeder.run(connection);
  await IngresoSeeder.run(connection);
  await EgresoSeeder.run(connection);
  await RegistraSeeder.run(connection);
  await AsistenciaSesionSeeder.run(connection);
  await MiembroMinisterioSeeder.run(connection);
  await AuditoriaSeeder.runSimple(connection);
  await UserProfileSeeder.run(connection);
  await RolUsuarioSeeder.run(connection);
  await PersonalAccessTokenSeeder.run(connection);
}

Future<void> _runSpecific(
  MySQLConnection connection,
  String seederName,
  String? passwordHash,
) async {
  switch (seederName) {
    case 'RolSeeder':
      await RolSeeder.run(connection);
      break;
    case 'UsuarioSeeder':
      await UsuarioSeeder.run(connection, hashPassword: passwordHash);
      break;
    case 'CargoSeeder':
      await CargoSeeder.run(connection);
      break;
    case 'MiembroSeeder':
      await MiembroSeeder.run(connection);
      break;
    case 'MinisterioSeeder':
      await MinisterioSeeder.run(connection);
      break;
    case 'DocenteSeeder':
      await DocenteSeeder.run(connection);
      break;
    case 'CursoSeeder':
      await CursoSeeder.run(connection);
      break;
    case 'SesionSeeder':
      await SesionSeeder.run(connection);
      break;
    case 'DocenteCursoSeeder':
      await DocenteCursoSeeder.run(connection);
      break;
    case 'ActividadSeeder':
      await ActividadSeeder.run(connection);
      break;
    case 'SeguimientoActividadSeeder':
      await SeguimientoActividadSeeder.run(connection);
      break;
    case 'LiderIglesiaSeeder':
      await LiderIglesiaSeeder.run(connection);
      break;
    case 'ContratoSeeder':
      await ContratoSeeder.run(connection);
      break;
    case 'CultoSeeder':
      await CultoSeeder.run(connection);
      break;
    case 'InscripcionSeeder':
      await InscripcionSeeder.run(connection);
      break;
    case 'PagoCursoSeeder':
      await PagoCursoSeeder.run(connection);
      break;
    case 'IngresoSeeder':
      await IngresoSeeder.run(connection);
      break;
    case 'EgresoSeeder':
      await EgresoSeeder.run(connection);
      break;
    case 'RegistraSeeder':
      await RegistraSeeder.run(connection);
      break;
    case 'AsistenciaSesionSeeder':
      await AsistenciaSesionSeeder.run(connection);
      break;
    case 'MiembroMinisterioSeeder':
      await MiembroMinisterioSeeder.run(connection);
      break;
    case 'AuditoriaSeeder':
      await AuditoriaSeeder.runSimple(connection);
      break;
    case 'UserProfileSeeder':
    case 'UsuarioPerfilSeeder':
      await UserProfileSeeder.run(connection);
      break;
    case 'RolUsuarioSeeder':
      await RolUsuarioSeeder.run(connection);
      break;
    case 'PersonalAccessTokenSeeder':
      await PersonalAccessTokenSeeder.run(connection);
      break;
    default:
      print('Seeder no encontrado: $seederName');
      return;
  }
  print('Seeder $seederName ejecutado');
}
