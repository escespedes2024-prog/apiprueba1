import 'package:apiprueba1/database/factories/base_factory.dart';

class CultoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'nombre': faker.lorem.words(2).join(' '),
      'dia_semana': faker.randomGenerator.element(['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo']),
      'hora': '${faker.randomGenerator.integer(22, min: 8).toString().padLeft(2, '0')}:00:00',
      'descripcion': faker.lorem.sentence(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
