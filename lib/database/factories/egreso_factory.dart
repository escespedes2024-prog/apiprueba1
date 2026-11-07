import 'package:apiprueba1/database/factories/base_factory.dart';

class EgresoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'tipo_egreso': faker.randomGenerator.element(['materiales', 'servicios', 'sueldos', 'mantenimiento', 'otro']),
      'descripcion': faker.lorem.sentence(),
      'monto': faker.randomGenerator.integer(1000, min: 10).toDouble(),
      'fecha': DateTime(now.year, now.month, now.day - faker.randomGenerator.integer(60))
          .toIso8601String()
          .split('T')
          .first,
      'responsable': faker.person.name(),
      'comprobante': faker.lorem.word(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
