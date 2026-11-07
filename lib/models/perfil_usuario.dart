import 'modelo.dart';

const modeloPerfilUsuario = Modelo(
  tabla: 'user_profiles',
  clavesPrimarias: ['id'],
  buscables: ['username', 'telefono'],
  columnas: [
    'id',
    'user_id',
    'username',
    'telefono',
    'estado',
    'fecha_registro',
    'created_at',
    'updated_at',
  ],
);
