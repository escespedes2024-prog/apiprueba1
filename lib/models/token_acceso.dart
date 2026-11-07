import 'modelo.dart';

const modeloTokenAcceso = Modelo(
  tabla: 'personal_access_tokens',
  clavesPrimarias: ['id'],
  ignoradas: ['token'],
  buscables: ['name'],
  columnas: [
    'id',
    'tokenable_type',
    'tokenable_id',
    'name',
    'token',
    'abilities',
    'last_used_at',
    'expires_at',
    'created_at',
    'updated_at',
  ],
);
