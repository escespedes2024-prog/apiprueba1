import 'modelo.dart';

const modeloSeguimientoActividad = Modelo(
  tabla: 'seguimiento_actividades',
  clavesPrimarias: ['id'],
  buscables: ['estado', 'observacion', 'responsable'],
  borradoLogico: true,
  columnas: [
    'id',
    'id_actividad',
    'fecha_registro',
    'estado',
    'observacion',
    'responsable',
    'porcentaje_avance',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
