import 'modelo.dart';
import 'relacion.dart';

const modeloMinisterio = Modelo(
  tabla: 'ministerios',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'descripcion'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'lider',
      tabla: 'lideres_iglesia',
      claveLocal: 'id_lider_iglesia',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'id_cargo', 'telefono', 'activo'],
      borradoLogico: true,
    ),
    Relacion.varias(
      alias: 'miembros',
      tabla: 'miembro_ministerio',
      claveLocal: 'id',
      claveRemota: 'ministerio_id',
      columnas: ['id', 'miembro_id', 'fecha_inicio', 'fecha_fin'],
    ),
  ],
  columnas: [
    'id',
    'nombre',
    'descripcion',
    'id_lider_iglesia',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
