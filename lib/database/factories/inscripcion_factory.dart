import 'package:apiprueba1/database/factories/base_factory.dart';

class InscripcionFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'fecha_inscripcion': DateTime(now.year, now.month, now.day - faker.randomGenerator.integer(30))
          .toIso8601String()
          .split('T')
          .first,
      'estado': faker.randomGenerator.element(['Activo', 'Pendiente', 'Cancelado']),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
