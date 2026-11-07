import 'package:apiprueba1/database/factories/base_factory.dart';

class CargoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'nombre': faker.job.title(),
      'descripcion': faker.lorem.sentence(),
      'nivel_jerarquico': faker.randomGenerator.integer(10, min: 1),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
