import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/layouts/content_container.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import 'hero_ridge.dart';
import 'hero_search_panel.dart';

/// Homepage hero: headline, two calls to action, and the search panel.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final headlineStyle = context.responsive(
      mobile: text.displaySmall,
      tablet: text.displayMedium,
      desktop: text.displayLarge,
    );
    final vertical = context.responsive(mobile: 56.0, tablet: 72.0, desktop: 96.0);

    return ColoredBox(
      color: AppColors.forest,
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroBackground()),
          ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vertical),
              child: Column(
                children: [
                  const AppBadge(
                    label: 'Domestic and international travel',
                    tone: BadgeTone.gold,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppConfig.tagline,
                    textAlign: TextAlign.center,
                    style: headlineStyle?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      'Family holidays, honeymoons, treks, and international escapes, planned around you.',
                      textAlign: TextAlign.center,
                      style: text.bodyLarge?.copyWith(color: AppColors.offWhite),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      AppButton(
                        label: 'Explore Destinations',
                        icon: Icons.explore_outlined,
                        variant: AppButtonVariant.gold,
                        onPressed: () => context.go(AppRoutes.destinations),
                      ),
                      AppButton(
                        label: 'Browse Tour Packages',
                        variant: AppButtonVariant.outlineLight,
                        onPressed: () => context.go(AppRoutes.packages),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: const HeroSearchPanel(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    if (AppImages.hero.isEmpty) return const HeroRidge();
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          AppImages.hero,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const HeroRidge(),
        ),
        const ColoredBox(color: Color(0xB30B3B35)),
      ],
    );
  }
}