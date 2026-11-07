import 'package:apiprueba1/database/factories/base_factory.dart';

class CursoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final fInicio = DateTime(now.year, now.month, now.day + faker.randomGenerator.integer(30));
    final fFin = DateTime(fInicio.year, fInicio.month + faker.randomGenerator.integer(3, min: 1), fInicio.day);
    final tienePago = faker.randomGenerator.boolean();
    final data = <String, dynamic>{
      'nombre': faker.lorem.words(3).join(' '),
      'f_inicio': fInicio.toIso8601String().split('T').first,
      'f_fin': fFin.toIso8601String().split('T').first,
      'cupo_max': faker.randomGenerator.integer(50, min: 10),
      'tiene_pago': tienePago ? 1 : 0,
      'monto_inscripcion': tienePago ? faker.randomGenerator.integer(100, min: 10).toDouble() : 0.0,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
