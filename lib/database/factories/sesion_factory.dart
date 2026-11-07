import 'package:apiprueba1/database/factories/base_factory.dart';

class SesionFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'fecha': DateTime(now.year, now.month, now.day + faker.randomGenerator.integer(60))
          .toIso8601String()
          .split('T')
          .first,
      'hora': '19:30:00',
      'tema': faker.lorem.words(4).join(' ').replaceAll('.', ''),
      'observacion': faker.lorem.sentence(),
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
