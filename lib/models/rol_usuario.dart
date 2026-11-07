import 'modelo.dart';

const modeloRolUsuario = Modelo(
  tabla: 'role_user',
  clavesPrimarias: ['user_id', 'role_id'],
  borradoLogico: true,
  columnas: [
    'user_id',
    'role_id',
    'fecha_asignacion',
    'estado',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
