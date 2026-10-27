import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/destination.dart';
import 'destination_repository.dart';
import 'mock_destination_repository.dart';

/// The single place to swap mock data for Firebase in Phase 2.
final destinationRepositoryProvider = Provider<DestinationRepository>(
  (ref) => const MockDestinationRepository(),
);

final destinationsProvider = FutureProvider<List<Destination>>(
  (ref) => ref.watch(destinationRepositoryProvider).getAll(),
);

final destinationProvider = FutureProvider.family<Destination?, String>(
  (ref, id) => ref.watch(destinationRepositoryProvider).getById(id),
);