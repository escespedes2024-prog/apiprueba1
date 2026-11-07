import 'modelo.dart';
import 'relacion.dart';

const modeloContrato = Modelo(
  tabla: 'contratos',
  clavesPrimarias: ['id'],
  buscables: ['tipo_compensacion', 'descripcion', 'estado'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'miembro',
      tabla: 'miembros',
      claveLocal: 'id_miembro',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'email', 'telefono'],
      borradoLogico: true,
    ),
    Relacion.una(
      alias: 'lider_iglesia',
      tabla: 'lideres_iglesia',
      claveLocal: 'id_lider_iglesia',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'id_cargo'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_miembro',
    'id_lider_iglesia',
    'tipo_compensacion',
    'salario',
    'descripcion',
    'fecha_inicio',
    'fecha_fin',
    'activo',
    'monto',
    'estado',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
