import 'package:apiprueba1/database/factories/base_factory.dart';

class AsistenciaSesionFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'estado': faker.randomGenerator.element(['presente', 'ausente', 'justificado']),
      'observacion': faker.lorem.sentence(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
