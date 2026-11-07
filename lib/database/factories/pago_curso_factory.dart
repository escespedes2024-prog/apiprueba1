import 'package:apiprueba1/database/factories/base_factory.dart';

class PagoCursoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'monto': faker.randomGenerator.integer(200, min: 10).toDouble(),
      'fecha_pago': now.toIso8601String().split('T').first,
      'metodo_pago': faker.randomGenerator.element(['efectivo', 'transferencia', 'tarjeta']),
      'comprobante': faker.lorem.word(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
