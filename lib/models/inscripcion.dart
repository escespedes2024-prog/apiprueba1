import 'modelo.dart';
import 'relacion.dart';

const modeloInscripcion = Modelo(
  tabla: 'inscripciones',
  clavesPrimarias: ['id'],
  buscables: ['estado'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'miembro',
      tabla: 'miembros',
      claveLocal: 'miembro_id',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'email', 'telefono'],
      borradoLogico: true,
    ),
    Relacion.una(
      alias: 'curso',
      tabla: 'cursos',
      claveLocal: 'curso_id',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'f_inicio', 'f_fin', 'monto_inscripcion'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'miembro_id',
    'curso_id',
    'fecha_inscripcion',
    'estado',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
