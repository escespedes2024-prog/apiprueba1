import 'package:apiprueba1/database/factories/base_factory.dart';

class ContratoFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final fInicio = DateTime(now.year - faker.randomGenerator.integer(2).toInt(), 1, 1);
    final fFin = DateTime(fInicio.year + faker.randomGenerator.integer(2, min: 1).toInt(), 12, 31);
    final activo = faker.randomGenerator.boolean();
    final data = <String, dynamic>{
      'tipo_compensacion': faker.randomGenerator.element(['Salario', 'Honorario', 'Aporte']),
      'salario': faker.randomGenerator.integer(5000, min: 1000).toDouble(),
      'descripcion': faker.lorem.sentence(),
      'fecha_inicio': fInicio.toIso8601String().split('T').first,
      'fecha_fin': activo ? null : fFin.toIso8601String().split('T').first,
      'activo': activo ? 1 : 0,
      'monto': faker.randomGenerator.integer(5000, min: 1000).toDouble(),
      'estado': activo ? 'activo' : faker.randomGenerator.element(['finalizado', 'cancelado']),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
