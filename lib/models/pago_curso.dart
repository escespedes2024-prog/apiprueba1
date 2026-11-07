import 'modelo.dart';

const modeloPagoCurso = Modelo(
  tabla: 'pago_cursos',
  clavesPrimarias: ['id'],
  buscables: ['metodo_pago', 'comprobante'],
  borradoLogico: true,
  columnas: [
    'id',
    'inscripcion_id',
    'monto',
    'fecha_pago',
    'metodo_pago',
    'comprobante',
    'registrado_por',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
