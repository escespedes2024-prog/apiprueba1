import 'package:apiprueba1/database/factories/base_factory.dart';

class SeguimientoActividadFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'fecha_registro': now.toIso8601String().split('T').first,
      'estado': faker.randomGenerator.element(['pendiente', 'en_proceso', 'completado']),
      'observacion': faker.lorem.sentence(),
      'responsable': faker.person.name(),
      'porcentaje_avance': faker.randomGenerator.integer(100, min: 0).toDouble(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
