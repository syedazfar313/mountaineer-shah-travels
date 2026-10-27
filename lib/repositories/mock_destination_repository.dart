import '../mock_data/mock_destinations.dart';
import '../models/destination.dart';
import 'destination_repository.dart';

class MockDestinationRepository implements DestinationRepository {
  const MockDestinationRepository();

  @override
  Future<List<Destination>> getAll() async => mockDestinations;

  @override
  Future<Destination?> getById(String id) async {
    for (final destination in mockDestinations) {
      if (destination.id == id) return destination;
    }
    return null;
  }
}