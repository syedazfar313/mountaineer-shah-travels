import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Row of five stars for a rating from 0 to 5, with half-star steps.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  IconData _iconFor(int position) {
    if (rating >= position) return Icons.star;
    if (rating >= position - 0.5) return Icons.star_half;
    return Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${rating.toStringAsFixed(1)} out of 5 stars',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(_iconFor(i), size: size, color: AppColors.goldDeep),
          ],
        ),
      ),
    );
  }
}