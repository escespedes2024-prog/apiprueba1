import 'package:apiprueba1/database/factories/base_factory.dart';

class ActividadFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'nombre': faker.lorem.words(3).join(' '),
      'fecha': DateTime(now.year, now.month, now.day + faker.randomGenerator.integer(30).toInt())
          .toIso8601String()
          .split('T')
          .first,
      'lugar': faker.address.city(),
      'estado': faker.randomGenerator.element(['planificada', 'en_curso', 'completada', 'cancelada']),
      'descripcion': faker.lorem.sentence(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
