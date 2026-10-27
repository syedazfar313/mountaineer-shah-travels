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