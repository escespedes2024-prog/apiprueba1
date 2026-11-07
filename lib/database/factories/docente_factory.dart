import 'package:apiprueba1/database/factories/base_factory.dart';

class DocenteFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final data = <String, dynamic>{
      'especialidad': faker.job.title(),
      'titulo': faker.randomGenerator.element([
        'Licenciado en Ciencias Bíblicas',
        'Teólogo',
        'Maestro Bíblico',
        'Pastor',
      ]),
      'activo': 1,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
