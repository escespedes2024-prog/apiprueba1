import 'package:apiprueba1/database/factories/base_factory.dart';

class MinisterioFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'nombre': faker.lorem.words(3).join(' '),
      'descripcion': faker.lorem.sentence(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
