import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tour_package.dart';
import 'mock_package_repository.dart';
import 'package_repository.dart';

/// The single place to swap mock data for Firebase in Phase 2.
final packageRepositoryProvider = Provider<PackageRepository>(
  (ref) => const MockPackageRepository(),
);

final packagesProvider = FutureProvider<List<TourPackage>>(
  (ref) => ref.watch(packageRepositoryProvider).getAll(),
);

final packageProvider = FutureProvider.family<TourPackage?, String>(
  (ref, id) => ref.watch(packageRepositoryProvider).getById(id),
);