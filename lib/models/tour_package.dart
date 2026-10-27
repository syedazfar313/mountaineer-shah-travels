import 'package:flutter/foundation.dart';

import 'tour_category.dart';

@immutable
class ItineraryDay {
  const ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
  });

  final int day;
  final String title;
  final String description;
}

@immutable
class TourPackage {
  const TourPackage({
    required this.id,
    required this.name,
    required this.destinationId,
    required this.destinationName,
    required this.description,
    required this.coverImageUrl,
    required this.durationDays,
    required this.price,
    required this.currency,
    required this.priceBasis,
    required this.category,
    this.galleryUrls = const [],
    this.itinerary = const [],
    this.accommodation = '',
    this.transport = '',
    this.included = const [],
    this.excluded = const [],
    this.travelDates = const [],
    this.availabilityNote,
    this.rating,
    this.isSample = true,
  });

  final String id;
  final String name;
  final String destinationId;
  final String destinationName;
  final String description;
  final String coverImageUrl;
  final List<String> galleryUrls;
  final int durationDays;
  final double price;
  final String currency;

  /// For example "per person" or "per couple".
  final String priceBasis;
  final TourCategory category;
  final List<ItineraryDay> itinerary;
  final String accommodation;
  final String transport;
  final List<String> included;
  final List<String> excluded;
  final List<DateTime> travelDates;
  final String? availabilityNote;
  final double? rating;

  /// True while price, rating, and availability are illustrative demo values.
  final bool isSample;
}