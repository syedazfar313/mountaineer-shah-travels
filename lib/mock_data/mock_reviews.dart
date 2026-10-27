import '../models/review.dart';

/// Fictional sample reviews for Phase 1, not real customer feedback.
final List<Review> mockReviews = [
  Review(
    id: 'review-1',
    authorName: 'Sample Traveler A',
    location: 'Lahore',
    rating: 5,
    comment:
        'The itinerary was easy to follow and the driver was patient with the children.',
    date: DateTime(2026, 8, 12),
    packageId: 'hunza-family-escape',
  ),
  Review(
    id: 'review-2',
    authorName: 'Sample Traveler B',
    location: 'Islamabad',
    rating: 4.5,
    comment:
        'Quiet riverside stay and well-planned days. Perfect for a honeymoon.',
    date: DateTime(2026, 9, 3),
    packageId: 'kashmir-neelum-honeymoon',
  ),
  Review(
    id: 'review-3',
    authorName: 'Sample Traveler C',
    location: 'Karachi',
    rating: 5,
    comment:
        'Deosai was unforgettable. The guide knew every stop and kept the group on time.',
    date: DateTime(2026, 7, 21),
    packageId: 'skardu-deosai-adventure',
  ),
  Review(
    id: 'review-4',
    authorName: 'Sample Traveler D',
    location: 'Rawalpindi',
    rating: 4,
    comment:
        'A challenging trek, but the team looked after us well at every camp.',
    date: DateTime(2026, 8, 30),
    packageId: 'fairy-meadows-trek',
  ),
  Review(
    id: 'review-5',
    authorName: 'Sample Traveler E',
    location: 'Faisalabad',
    rating: 4.5,
    comment: 'Smooth transfers and a good mix of sightseeing and free time.',
    date: DateTime(2026, 3, 14),
    packageId: 'dubai-city-and-desert',
  ),
  Review(
    id: 'review-6',
    authorName: 'Sample Traveler F',
    location: 'Peshawar',
    rating: 5,
    comment:
        'Clear communication before the trip and quick answers whenever we had a question.',
    date: DateTime(2026, 5, 9),
  ),
];