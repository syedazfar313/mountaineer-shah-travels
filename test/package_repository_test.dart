import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/models/tour_category.dart';
import 'package:mountaineer_shah_travels/repositories/mock_destination_repository.dart';
import 'package:mountaineer_shah_travels/repositories/mock_package_repository.dart';

void main() {
  const packages = MockPackageRepository();
  const destinations = MockDestinationRepository();

  test('every tour category has at least one package', () async {
    final all = await packages.getAll();
    final used = all.map((p) => p.category).toSet();

    expect(used, containsAll(TourCategory.values));
  });

  test('package ids are unique', () async {
    final all = await packages.getAll();

    expect(all.map((p) => p.id).toSet().length, all.length);
  });

  test('every package points to a real destination', () async {
    final all = await packages.getAll();
    final destinationIds =
        (await destinations.getAll()).map((d) => d.id).toSet();

    for (final package in all) {
      expect(destinationIds, contains(package.destinationId),
          reason: package.id);
    }
  });

  test('itineraries are complete and prices are positive', () async {
    final all = await packages.getAll();

    for (final package in all) {
      expect(package.price, greaterThan(0), reason: package.id);
      expect(package.isSample, isTrue, reason: package.id);
      expect(package.itinerary.length, package.durationDays,
          reason: package.id);
      for (var i = 0; i < package.itinerary.length; i++) {
        expect(package.itinerary[i].day, i + 1, reason: package.id);
      }
    }
  });

  test('lookup by id and by destination', () async {
    final skardu = await packages.getById('skardu-deosai-adventure');
    final unknown = await packages.getById('does-not-exist');
    final hunza = await packages.getByDestinationId('hunza');

    expect(skardu?.destinationId, 'skardu');
    expect(unknown, isNull);
    expect(hunza.length, greaterThanOrEqualTo(2));
  });
}