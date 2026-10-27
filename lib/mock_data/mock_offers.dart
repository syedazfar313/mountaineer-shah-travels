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