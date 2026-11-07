import 'modelo.dart';

const modeloUsuario = Modelo(
  tabla: 'users',
  clavesPrimarias: ['id'],
  ignoradas: ['password', 'remember_token'],
  buscables: ['name', 'email'],
  borradoLogico: true,
  columnas: [
    'id',
    'name',
    'email',
    'email_verified_at',
    'password',
    'remember_token',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
