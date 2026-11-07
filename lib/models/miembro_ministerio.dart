import 'modelo.dart';

const modeloMiembroMinisterio = Modelo(
  tabla: 'miembro_ministerio',
  clavesPrimarias: ['id'],
  borradoLogico: true,
  columnas: [
    'id',
    'miembro_id',
    'ministerio_id',
    'cargo_id',
    'fecha_inicio',
    'fecha_fin',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
