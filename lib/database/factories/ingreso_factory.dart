import 'package:apiprueba1/database/factories/base_factory.dart';

class IngresoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'monto_total': faker.randomGenerator.integer(1000, min: 10).toDouble(),
      'fecha': DateTime(now.year, now.month, now.day - faker.randomGenerator.integer(60))
          .toIso8601String()
          .split('T')
          .first,
      'tipo': faker.randomGenerator.element(['ofrenda', 'donacion', 'matricula', 'venta']),
      'metodo_pago': faker.randomGenerator.element(['efectivo', 'transferencia', 'tarjeta']),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
