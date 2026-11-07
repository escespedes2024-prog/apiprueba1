import 'modelo.dart';
import 'relacion.dart';

const modeloCurso = Modelo(
  tabla: 'cursos',
  clavesPrimarias: ['id'],
  buscables: ['nombre'],
  borradoLogico: true,
  relaciones: [
    Relacion.varias(
      alias: 'sesiones',
      tabla: 'sesiones',
      claveLocal: 'id',
      claveRemota: 'id_curso',
      columnas: ['id', 'id_docente', 'fecha', 'hora', 'tema'],
    ),
  ],
  columnas: [
    'id',
    'nombre',
    'f_inicio',
    'f_fin',
    'cupo_max',
    'dias_semana',
    'hora_inicio',
    'hora_fin',
    'tiene_pago',
    'monto_inscripcion',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
