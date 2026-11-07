import 'modelo.dart';
import 'relacion.dart';

const modeloActividad = Modelo(
  tabla: 'actividades',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'lugar', 'descripcion'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'ministerio',
      tabla: 'ministerios',
      claveLocal: 'id_ministerio',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'id_lider'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_ministerio',
    'nombre',
    'fecha',
    'lugar',
    'estado',
    'descripcion',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
