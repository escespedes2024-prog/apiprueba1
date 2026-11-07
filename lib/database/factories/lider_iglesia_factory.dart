import 'package:apiprueba1/database/factories/base_factory.dart';

class LiderIglesiaFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'nombre': faker.person.name(),
      'telefono': faker.phoneNumber.us().replaceAll(RegExp(r'\D'), '').substring(0, 8),
      'fecha_inicio': DateTime(now.year - faker.randomGenerator.integer(5), 1, 1).toIso8601String().split('T').first,
      'activo': 1,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
