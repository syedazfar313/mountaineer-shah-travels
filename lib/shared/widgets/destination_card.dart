import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/destination.dart';
import 'app_badge.dart';
import 'app_image.dart';
import 'hover_surface.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  final Destination destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return HoverSurface(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                url: destination.imageUrl,
                aspectRatio: 4 / 3,
                semanticLabel: destination.name,
              ),
              Positioned(
                left: AppSpacing.md - 4,
                top: AppSpacing.md - 4,
                child: AppBadge(
                  label: destination.region.label,
                  tone: BadgeTone.gold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: text.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  destination.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(color: AppColors.muted),
                ),
                if (destination.bestSeason != null) ...[
                  const SizedBox(height: AppSpacing.md - 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 16,
                        color: AppColors.goldDeep,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Best time: ${destination.bestSeason}',
                          style: text.bodySmall,
                        ),
                      ),
                    ],
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