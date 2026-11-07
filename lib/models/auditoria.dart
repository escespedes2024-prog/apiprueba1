import 'modelo.dart';

const modeloAuditoria = Modelo(
  tabla: 'auditorias',
  clavesPrimarias: ['id'],
  columnas: ['id', 'created_at', 'updated_at'],
);
