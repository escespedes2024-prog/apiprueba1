import 'modelo.dart';

const modeloCargo = Modelo(
  tabla: 'cargos',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'descripcion'],
  borradoLogico: true,
  columnas: [
    'id',
    'nombre',
    'descripcion',
    'nivel_jerarquico',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
