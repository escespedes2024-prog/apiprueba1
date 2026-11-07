import 'package:apiprueba1/database/factories/base_factory.dart';

class UserProfileFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'username': faker.internet.userName(),
      'telefono': faker.phoneNumber.us().replaceAll(RegExp(r'\D'), '').substring(0, 8),
      'estado': 'activo',
      'fecha_registro': now.toIso8601String().split('T').first,
    };

    if (overrides != null) {
      data.addAll(overrides);
    }
    return data;
  }
}
