import 'modelo.dart';
import 'relacion.dart';

const modeloIngreso = Modelo(
  tabla: 'ingresos',
  clavesPrimarias: ['id'],
  buscables: ['tipo', 'metodo_pago'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'actividad',
      tabla: 'actividades',
      claveLocal: 'id_actividad',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'fecha', 'estado'],
      borradoLogico: true,
    ),
    Relacion.una(
      alias: 'culto',
      tabla: 'cultos',
      claveLocal: 'id_culto',
      claveRemota: 'id_culto',
      columnas: ['id_culto', 'nombre', 'dia_semana', 'hora'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_actividad',
    'id_culto',
    'pago_curso_id',
    'monto_total',
    'fecha',
    'tipo',
    'metodo_pago',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
