import 'package:mysql_client/mysql_client.dart';

import '../models/ingreso.dart';
import 'service_crud.dart';

class ServiceIngreso extends ServiceCrud {
  ServiceIngreso(MySQLConnection connection) : super(connection, modeloIngreso);

  Future<Map<String, dynamic>> resumenFinanciero({
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final rango = <String, dynamic>{};
    if (desde != null) rango['desde'] = _formatearFecha(desde);
    if (hasta != null) rango['hasta'] = _formatearFecha(hasta);

    String rangoFechas(String tabla) => [
          '$tabla.deleted_at IS NULL',
          if (rango.containsKey('desde')) '$tabla.fecha >= :desde',
          if (rango.containsKey('hasta')) '$tabla.fecha <= :hasta',
        ].join(' AND ');

    final resultado = await connection.execute('''
      SELECT
        (SELECT COALESCE(SUM(monto_total), 0) FROM ingresos
          WHERE ${rangoFechas('ingresos')}) AS total_ingresos,
        (SELECT COALESCE(SUM(monto), 0) FROM egresos
          WHERE ${rangoFechas('egresos')}) AS total_egresos
    ''', rango);

    final fila = resultado.rows.isEmpty ? null : resultado.rows.first;
    final ingresos = double.tryParse(fila?.colAt(0) ?? '0') ?? 0;
    final egresos = double.tryParse(fila?.colAt(1) ?? '0') ?? 0;

    return {
      'desde': rango['desde'],
      'hasta': rango['hasta'],
      'total_ingresos': ingresos,
      'total_egresos': egresos,
      'balance': ingresos - egresos,
    };
  }

  String _formatearFecha(DateTime fecha) {
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return '${fecha.year}-$mes-$dia';
  }
}
