import '../models/destination.dart';

/// Where destination data comes from. Phase 1 uses mock data; Phase 2 will
/// add a Firestore implementation without changing any screen.
abstract interface class DestinationRepository {
  Future<List<Destination>> getAll();

  Future<Destination?> getById(String id);
}