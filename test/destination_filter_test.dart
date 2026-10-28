import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/features/destinations/domain/destination_filter.dart';
import 'package:mountaineer_shah_travels/models/destination.dart';
import 'package:mountaineer_shah_travels/repositories/mock_destination_repository.dart';

void main() {
  late List<Destination> all;

  setUp(() async {
    all = await const MockDestinationRepository().getAll();
  });

  test('no filters returns every destination', () {
    expect(filterDestinations(all).length, all.length);
  });

  test('region filter splits Pakistan and international', () {
    final pakistan =
        filterDestinations(all, region: DestinationRegion.pakistan);
    final international =
        filterDestinations(all, region: DestinationRegion.international);

    expect(pakistan.length, 8);
    expect(international.length, 8);
  });

  test('name search ignores case', () {
    final result = filterDestinations(all, query: 'HUNZA');

    expect(result.length, 1);
    expect(result.first.id, 'hunza');
  });

  test('search ignores accents so turkiye finds T\u00FCrkiye', () {
    final result = filterDestinations(all, query: 'turkiye');

    expect(result.length, 1);
    expect(result.first.id, 'turkiye');
  });

  test('search also matches highlights', () {
    final result = filterDestinations(all, query: 'attabad');

    expect(result.map((d) => d.id), contains('hunza'));
  });

  test('region and search combine', () {
    final result = filterDestinations(
      all,
      query: 'hunza',
      region: DestinationRegion.international,
    );

    expect(result, isEmpty);
  });

  test('a search with no match returns an empty list', () {
    expect(filterDestinations(all, query: 'zzzz'), isEmpty);
  });
}