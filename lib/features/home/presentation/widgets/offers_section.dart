import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../models/offer.dart';
import '../../../../repositories/offer_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// Seasonal promotions. All offers here are illustrative samples.
class OffersSection extends ConsumerWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);

    return HomeSection(
      title: 'Seasonal offers',
      subtitle:
          'Sample promotions for illustration. These discounts and dates are not real offers.',
      child: offers.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyView(
              title: 'No offers right now',
              message: 'Seasonal offers will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [for (final offer in list) _OfferCard(offer: offer)],
          );
        },
        loading: () => const SizedBox(
          height: 240,
          child: LoadingView(message: 'Loading offers'),
        ),
        error: (error, stackTrace) => ErrorView(
          message: 'Offers could not be loaded.',
          onRetry: () => ref.invalidate(offersProvider),
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBadge(label: offer.season, tone: BadgeTone.gold),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${offer.discountPercent}% off',
              style: text.displaySmall?.copyWith(color: AppColors.gold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              offer.title,
              style: text.titleLarge?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              offer.description,
              style: text.bodyMedium?.copyWith(color: AppColors.offWhite),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Valid until ${formatMonthYear(offer.validUntil)}',
              style: text.bodySmall?.copyWith(color: AppColors.gold),
            ),
            if (offer.isSample)
              Text(
                'Sample offer, for illustration only.',
                style: text.labelSmall?.copyWith(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.w400,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Browse packages',
              variant: AppButtonVariant.outlineLight,
              onPressed: () => context.go(AppRoutes.packages),
            ),
          ],
        ),
      ),
    );
  }
}