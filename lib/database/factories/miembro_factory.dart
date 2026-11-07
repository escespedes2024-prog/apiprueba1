import 'package:apiprueba1/database/factories/base_factory.dart';

class MiembroFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'nombre': faker.person.name(),
      'email': faker.internet.email(),
      'telefono': faker.phoneNumber.us().replaceAll(RegExp(r'\D'), '').substring(0, 8),
      'f_nacimiento': faker.date.dateTime(minYear: 1970, maxYear: 2005).toIso8601String().split('T').first,
      'estado': 'activo',
      'direccion': faker.address.streetAddress(),
      'fecha_ingreso': DateTime(now.year - faker.randomGenerator.integer(5), 1, 1).toIso8601String().split('T').first,
      'sexo': faker.randomGenerator.element(['M', 'F', 'otro']),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
