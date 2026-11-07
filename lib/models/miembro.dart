import 'modelo.dart';
import 'relacion.dart';

const modeloMiembro = Modelo(
  tabla: 'miembros',
  clavesPrimarias: ['id'],
  buscables: ['nombre', 'email', 'telefono', 'direccion'],
  borradoLogico: true,
  relaciones: [
    Relacion.una(
      alias: 'docente',
      tabla: 'docentes',
      claveLocal: 'id',
      claveRemota: 'id_miembro',
      columnas: ['id', 'especialidad', 'titulo', 'activo'],
      borradoLogico: true,
    ),
    Relacion.varias(
      alias: 'contratos',
      tabla: 'contratos',
      claveLocal: 'id',
      claveRemota: 'id_miembro',
      columnas: [
        'id',
        'id_lider_iglesia',
        'tipo_compensacion',
        'salario',
        'fecha_inicio',
        'fecha_fin',
        'estado',
      ],
    ),
  ],
  columnas: [
    'id',
    'nombre',
    'email',
    'telefono',
    'f_nacimiento',
    'estado',
    'direccion',
    'fecha_ingreso',
    'sexo',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
