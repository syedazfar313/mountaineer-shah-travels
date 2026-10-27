import '../models/tour_package.dart';

/// Where tour package data comes from. Phase 1 uses mock data; Phase 2 will
/// add a Firestore implementation without changing any screen.
abstract interface class PackageRepository {
  Future<List<TourPackage>> getAll();

  Future<TourPackage?> getById(String id);

  Future<List<TourPackage>> getByDestinationId(String destinationId);
}