import '../models/review.dart';

/// Where reviews come from. Phase 1 uses mock data; Phase 2 will add a
/// Firestore implementation without changing any screen.
abstract interface class ReviewRepository {
  Future<List<Review>> getAll();
}