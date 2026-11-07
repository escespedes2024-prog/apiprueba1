import 'package:apiprueba1/database/factories/base_factory.dart';

class UserFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final nowTime = DateTime.now().toUtc().toString().replaceAll(' ', 'T');

    final data = <String, dynamic>{
      'name': faker.person.name(),
      'email': faker.internet.email(),
      'email_verified_at': nowTime,
      'password': r'$2b$12$4lMP8/jvQjg2tZpYDiQfOeXUPPjzMqOrtozywElwAeFl3pWSPRRiS', // password
      'remember_token': faker.guid.guid(),
      'created_at': nowTime,
      'updated_at': nowTime,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}