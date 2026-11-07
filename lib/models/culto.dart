import 'modelo.dart';

const modeloCulto = Modelo(
  tabla: 'cultos',
  clavesPrimarias: ['id_culto'],
  buscables: ['nombre', 'descripcion'],
  borradoLogico: true,
  columnas: [
    'id_culto',
    'nombre',
    'id_lider_iglesia',
    'dia_semana',
    'hora',
    'descripcion',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
