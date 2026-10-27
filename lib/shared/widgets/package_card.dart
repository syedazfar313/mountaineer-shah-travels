import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../models/tour_package.dart';
import 'app_badge.dart';
import 'app_image.dart';
import 'hover_surface.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package, required this.onTap});

  final TourPackage package;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rating = package.rating;

    return HoverSurface(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                url: package.coverImageUrl,
                semanticLabel: package.name,
              ),
              Positioned(
                left: AppSpacing.md - 4,
                top: AppSpacing.md - 4,
                child: AppBadge(
                  label: package.category.label,
                  tone: BadgeTone.gold,
                ),
              ),
              if (rating != null)
                Positioned(
                  right: AppSpacing.md - 4,
                  top: AppSpacing.md - 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.goldDeep,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: text.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                _MetaRow(
                  icon: Icons.location_on_outlined,
                  label: package.destinationName,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                _MetaRow(
                  icon: Icons.schedule,
                  label: formatDuration(package.durationDays),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'From',
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
                Text(
                  formatPrice(package.price, package.currency),
                  style: text.titleLarge?.copyWith(color: AppColors.forest),
                ),
                Text(
                  package.priceBasis,
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
                if (package.isSample) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sample price and rating, for illustration only.',
                    style: text.labelSmall?.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}