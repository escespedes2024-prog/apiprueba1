import 'modelo.dart';

const modeloRol = Modelo(
  tabla: 'roles',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'descripcion'],
  borradoLogico: true,
  columnas: [
    'id',
    'nombre',
    'descripcion',
    'estado',
    'nivel_acceso',
    'guard_name',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
