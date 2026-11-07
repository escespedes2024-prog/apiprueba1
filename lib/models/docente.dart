import 'modelo.dart';
import 'relacion.dart';

const modeloDocente = Modelo(
  tabla: 'docentes',
  clavesPrimarias: ['id'],
  buscables: ['especialidad', 'titulo'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'miembro',
      tabla: 'miembros',
      claveLocal: 'id_miembro',
      claveRemota: 'id',
      columnas: ['id', 'nombre', 'email', 'telefono', 'estado'],
      borradoLogico: true,
    ),
  ],
  columnas: [
    'id',
    'id_miembro',
    'especialidad',
    'titulo',
    'activo',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
