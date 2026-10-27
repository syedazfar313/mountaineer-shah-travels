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