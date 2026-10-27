import '../mock_data/mock_reviews.dart';
import '../models/review.dart';
import 'review_repository.dart';

class MockReviewRepository implements ReviewRepository {
  const MockReviewRepository();

  @override
  Future<List<Review>> getAll() async => mockReviews;
}