import '../mock_data/mock_packages.dart';
import '../models/tour_package.dart';
import 'package_repository.dart';

class MockPackageRepository implements PackageRepository {
  const MockPackageRepository();

  @override
  Future<List<TourPackage>> getAll() async => mockPackages;

  @override
  Future<TourPackage?> getById(String id) async {
    for (final package in mockPackages) {
      if (package.id == id) return package;
    }
    return null;
  }

  @override
  Future<List<TourPackage>> getByDestinationId(String destinationId) async {
    return mockPackages
        .where((package) => package.destinationId == destinationId)
        .toList();
  }
}