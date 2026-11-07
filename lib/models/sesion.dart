import 'modelo.dart';
import 'relacion.dart';

const modeloSesion = Modelo(
  tabla: 'sesiones',
  clavesPrimarias: ['id'],
  buscables: ['tema', 'observacion'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'curso',
      tabla: 'cursos',
      claveLocal: 'id_curso',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'f_inicio', 'f_fin', 'cupo_max'],
      borradoLogico: true,
    ),
    Relacion.una(
      alias: 'docente',
      tabla: 'docentes',
      claveLocal: 'id_docente',
      claveRemota: 'id',
      columnas: ['id', 'id_miembro', 'especialidad', 'titulo'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_curso',
    'id_docente',
    'fecha',
    'hora',
    'tema',
    'observacion',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
