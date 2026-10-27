import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/offer.dart';
import 'mock_offer_repository.dart';
import 'offer_repository.dart';

/// The single place to swap mock data for Firebase in Phase 2.
final offerRepositoryProvider = Provider<OfferRepository>(
  (ref) => const MockOfferRepository(),
);

final offersProvider = FutureProvider<List<Offer>>(
  (ref) => ref.watch(offerRepositoryProvider).getAll(),
);