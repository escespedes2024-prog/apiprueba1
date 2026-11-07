import 'package:apiprueba1/database/factories/base_factory.dart';

class MiembroMinisterioFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'fecha_inicio': DateTime(now.year - faker.randomGenerator.integer(3), 1, 1).toIso8601String().split('T').first,
      'fecha_fin': faker.randomGenerator.boolean()
          ? DateTime(now.year, now.month, now.day).toIso8601String().split('T').first
          : null,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
