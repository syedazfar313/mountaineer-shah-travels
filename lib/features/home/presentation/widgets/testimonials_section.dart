import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../models/review.dart';
import '../../../../repositories/review_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// Sample testimonials. They are fictional and clearly labelled as such.
class TestimonialsSection extends ConsumerWidget {
  const TestimonialsSection({super.key});

  static const int _shown = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);

    return HomeSection(
      title: 'What travelers say',
      subtitle:
          'Sample testimonials for illustration. These are fictional and are not real customer reviews.',
      child: reviews.when(
        data: (list) {
          final shown = list.take(_shown).toList();
          if (shown.isEmpty) {
            return const EmptyView(
              title: 'No reviews yet',
              message: 'Traveler reviews will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [
              for (final review in shown) _ReviewCard(review: review),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 240,
          child: LoadingView(message: 'Loading reviews'),
        ),
        error: (error, stackTrace) => ErrorView(
          message: 'Reviews could not be loaded.',
          onRetry: () => ref.invalidate(reviewsProvider),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StarRating(rating: review.rating),
                const SizedBox(width: AppSpacing.sm),
                Text(review.rating.toStringAsFixed(1), style: text.labelMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(review.comment, style: text.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            Text(review.authorName, style: text.titleSmall),
            Text(
              '${review.location}, ${formatMonthYear(review.date)}',
              style: text.bodySmall?.copyWith(color: AppColors.muted),
            ),
            if (review.isSample) ...[
              const SizedBox(height: AppSpacing.md),
              const AppBadge(label: 'Sample review'),
            ],
          ],
        ),
      ),
    );
  }
}