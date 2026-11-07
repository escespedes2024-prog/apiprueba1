import 'package:faker/faker.dart' as fakerLib;

abstract class BaseFactory<T> {
  final fakerLib.Faker _faker = fakerLib.Faker();

  fakerLib.Faker get faker => _faker;

  T make({Map<String, dynamic>? overrides});
  List<T> makeMany(int count, {Map<String, dynamic>? overrides}) {
    return List.generate(count, (_) => make(overrides: overrides));
  }
}