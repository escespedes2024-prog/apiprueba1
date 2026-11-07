import 'package:apiprueba1/database/factories/base_factory.dart';

class AuditoriaFactory extends BaseFactory<Map<String, dynamic>> {
  @override
  Map<String, dynamic> make({Map<String, dynamic>? overrides}) {
    return overrides ?? <String, dynamic>{};
  }
}
