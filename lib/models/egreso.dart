import 'modelo.dart';

const modeloEgreso = Modelo(
  tabla: 'egresos',
  clavesPrimarias: ['id'],
  buscables: ['tipo_egreso', 'descripcion', 'responsable', 'comprobante'],
  borradoLogico: true,
  columnas: [
    'id',
    'id_ministerio',
    'id_contrato',
    'tipo_egreso',
    'descripcion',
    'monto',
    'fecha',
    'responsable',
    'comprobante',
    'created_at',
    'updated_at',
    'deleted_at',
  ],
);
