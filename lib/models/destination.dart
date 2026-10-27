import 'package:flutter/foundation.dart';

enum DestinationRegion {
  pakistan('Pakistan'),
  international('International');

  const DestinationRegion(this.label);

  final String label;
}

@immutable
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    this.galleryUrls = const [],
    this.highlights = const [],
    this.bestSeason,
  });

  final String id;
  final String name;
  final String country;
  final DestinationRegion region;
  final String tagline;
  final String description;

  /// Remote URL today; may become a bundled asset or Firebase Storage URL later.
  final String imageUrl;
  final List<String> galleryUrls;
  final List<String> highlights;
  final String? bestSeason;
}