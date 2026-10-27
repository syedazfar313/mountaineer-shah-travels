import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review.dart';
import 'mock_review_repository.dart';
import 'review_repository.dart';

/// The single place to swap mock data for Firebase in Phase 2.
final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => const MockReviewRepository(),
);

final reviewsProvider = FutureProvider<List<Review>>(
  (ref) => ref.watch(reviewRepositoryProvider).getAll(),
);