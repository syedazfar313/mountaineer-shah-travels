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