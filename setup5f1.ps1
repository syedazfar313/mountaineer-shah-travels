Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\models\offer.dart' @'
import 'package:flutter/foundation.dart';

/// A seasonal promotion. Phase 1 offers are illustrative samples only.
@immutable
class Offer {
  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.season,
    required this.discountPercent,
    required this.validUntil,
    this.isSample = true,
  });

  final String id;
  final String title;
  final String description;
  final String season;
  final int discountPercent;
  final DateTime validUntil;

  /// True while the discount and dates are illustrative demo values.
  final bool isSample;
}
'@

W 'lib\models\review.dart' @'
import 'package:flutter/foundation.dart';

/// A customer review. Phase 1 reviews are fictional samples, not real
/// customer feedback.
@immutable
class Review {
  const Review({
    required this.id,
    required this.authorName,
    required this.location,
    required this.rating,
    required this.comment,
    required this.date,
    this.packageId,
    this.isSample = true,
  });

  final String id;
  final String authorName;
  final String location;
  final double rating;
  final String comment;
  final DateTime date;
  final String? packageId;
  final bool isSample;
}
'@

W 'lib\mock_data\mock_offers.dart' @'
import '../models/offer.dart';

/// Sample promotions for Phase 1. Discounts and dates are illustrative.
final List<Offer> mockOffers = [
  Offer(
    id: 'summer-north',
    title: 'Summer in the North',
    description:
        'A sample seasonal offer on Hunza, Skardu, and Fairy Meadows departures.',
    season: 'Summer',
    discountPercent: 10,
    validUntil: DateTime(2027, 8, 31),
  ),
  Offer(
    id: 'honeymoon-season',
    title: 'Honeymoon Season Offer',
    description:
        'A sample offer for couples booking the Neelum Valley or Maldives honeymoon packages.',
    season: 'Autumn',
    discountPercent: 8,
    validUntil: DateTime(2027, 10, 31),
  ),
  Offer(
    id: 'winter-gulf',
    title: 'Winter Gulf Escape',
    description:
        'A sample offer on Dubai city and desert holidays during the cooler months.',
    season: 'Winter',
    discountPercent: 12,
    validUntil: DateTime(2027, 2, 28),
  ),
];
'@

W 'lib\mock_data\mock_reviews.dart' @'
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
'@

W 'lib\repositories\offer_repository.dart' @'
import '../models/offer.dart';

/// Where offers come from. Phase 1 uses mock data; Phase 2 will add a
/// Firestore implementation without changing any screen.
abstract interface class OfferRepository {
  Future<List<Offer>> getAll();
}
'@

W 'lib\repositories\mock_offer_repository.dart' @'
import '../mock_data/mock_offers.dart';
import '../models/offer.dart';
import 'offer_repository.dart';

class MockOfferRepository implements OfferRepository {
  const MockOfferRepository();

  @override
  Future<List<Offer>> getAll() async => mockOffers;
}
'@

W 'lib\repositories\offer_providers.dart' @'
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
'@

W 'lib\repositories\review_repository.dart' @'
import '../models/review.dart';

/// Where reviews come from. Phase 1 uses mock data; Phase 2 will add a
/// Firestore implementation without changing any screen.
abstract interface class ReviewRepository {
  Future<List<Review>> getAll();
}
'@

W 'lib\repositories\mock_review_repository.dart' @'
import '../mock_data/mock_reviews.dart';
import '../models/review.dart';
import 'review_repository.dart';

class MockReviewRepository implements ReviewRepository {
  const MockReviewRepository();

  @override
  Future<List<Review>> getAll() async => mockReviews;
}
'@

W 'lib\repositories\review_providers.dart' @'
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
'@

W 'test\offer_review_repository_test.dart' @'
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/repositories/mock_offer_repository.dart';
import 'package:mountaineer_shah_travels/repositories/mock_package_repository.dart';
import 'package:mountaineer_shah_travels/repositories/mock_review_repository.dart';

void main() {
  const offers = MockOfferRepository();
  const reviews = MockReviewRepository();
  const packages = MockPackageRepository();

  test('offers are labelled samples with unique ids', () async {
    final all = await offers.getAll();

    expect(all, isNotEmpty);
    expect(all.map((o) => o.id).toSet().length, all.length);
    for (final offer in all) {
      expect(offer.isSample, isTrue, reason: offer.id);
      expect(offer.discountPercent, inInclusiveRange(1, 90), reason: offer.id);
    }
  });

  test('reviews are labelled samples with valid ratings', () async {
    final all = await reviews.getAll();

    expect(all, isNotEmpty);
    expect(all.map((r) => r.id).toSet().length, all.length);
    for (final review in all) {
      expect(review.isSample, isTrue, reason: review.id);
      expect(review.rating, inInclusiveRange(1, 5), reason: review.id);
      expect(review.comment.trim(), isNotEmpty, reason: review.id);
    }
  });

  test('reviews only point to packages that exist', () async {
    final packageIds = (await packages.getAll()).map((p) => p.id).toSet();

    for (final review in await reviews.getAll()) {
      final id = review.packageId;
      if (id != null) {
        expect(packageIds, contains(id), reason: review.id);
      }
    }
  });
}
'@

Write-Host ""
$mine = @(
  'lib\models\offer.dart',
  'lib\models\review.dart',
  'lib\mock_data\mock_offers.dart',
  'lib\mock_data\mock_reviews.dart',
  'lib\repositories\offer_repository.dart',
  'lib\repositories\mock_offer_repository.dart',
  'lib\repositories\offer_providers.dart',
  'lib\repositories\review_repository.dart',
  'lib\repositories\mock_review_repository.dart',
  'lib\repositories\review_providers.dart',
  'test\offer_review_repository_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5f1 done."