import 'modelo.dart';
import 'relacion.dart';

const modeloLiderIglesia = Modelo(
  tabla: 'lideres_iglesia',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'telefono'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'cargo',
      tabla: 'cargos',
      claveLocal: 'id_cargo',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'nivel_jerarquico'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_cargo',
    'nombre',
    'telefono',
    'fecha_inicio',
    'activo',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
