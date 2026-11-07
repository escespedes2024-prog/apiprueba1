import 'modelo.dart';

const modeloAsistenciaSesion = Modelo(
  tabla: 'asistencias_sesion',
  clavesPrimarias: ['id'],
  buscables: ['estado', 'observacion'],
  borradoLogico: true,
  columnas: [
    'id',
    'miembro_id',
    'user_id',
    'sesion_id',
    'estado',
    'observacion',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
