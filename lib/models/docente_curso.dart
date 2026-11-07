import 'modelo.dart';

const modeloDocenteCurso = Modelo(
  tabla: 'docente_curso',
  clavesPrimarias: ['id_docente', 'id_curso'],
  borradoLogico: true,
  columnas: [
    'id_docente',
    'id_curso',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
