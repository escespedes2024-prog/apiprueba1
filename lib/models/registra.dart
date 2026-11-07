import 'modelo.dart';

const modeloRegistra = Modelo(
  tabla: 'registra',
  clavesPrimarias: ['id_miembro', 'id_sesion'],
  buscables: ['estado', 'observacion'],
  columnas: [
    'id_miembro',
    'id_sesion',
    'estado',
    'observacion',
    'created_at',
    'updated_at',
  ],
);
