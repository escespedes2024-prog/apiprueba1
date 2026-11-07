import 'package:apiprueba1/database/factories/base_factory.dart';

class RolFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'nombre': faker.lorem.word(),
      'descripcion': faker.lorem.sentence(),
      'estado': 'activo',
      'nivel_acceso': faker.randomGenerator.integer(10, min: 1),
      'guard_name': 'web',
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
