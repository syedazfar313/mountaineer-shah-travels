import '../models/offer.dart';

/// Where offers come from. Phase 1 uses mock data; Phase 2 will add a
/// Firestore implementation without changing any screen.
abstract interface class OfferRepository {
  Future<List<Offer>> getAll();
}