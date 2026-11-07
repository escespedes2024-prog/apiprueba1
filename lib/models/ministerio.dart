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
      tabla: 'miembros',
      claveLocal: 'id_lider',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'email', 'telefono'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'nombre',
    'descripcion',
    'id_lider',
    'created_at',
    'updated_at',
    'deleted_at',
    'liderable_type',
    'liderable_id',
  ],
);
