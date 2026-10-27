import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/models/destination.dart';
import 'package:mountaineer_shah_travels/repositories/mock_destination_repository.dart';

void main() {
  const repository = MockDestinationRepository();

  test('has 8 Pakistan and 8 international destinations', () async {
    final all = await repository.getAll();
    final pakistan =
        all.where((d) => d.region == DestinationRegion.pakistan).length;
    final international =
        all.where((d) => d.region == DestinationRegion.international).length;

    expect(pakistan, 8);
    expect(international, 8);
  });

  test('destination ids are unique', () async {
    final all = await repository.getAll();
    final ids = all.map((d) => d.id).toSet();

    expect(ids.length, all.length);
  });

  test('getById finds a destination and returns null for unknown ids', () async {
    final hunza = await repository.getById('hunza');
    final unknown = await repository.getById('does-not-exist');

    expect(hunza?.name, 'Hunza');
    expect(unknown, isNull);
  });
}