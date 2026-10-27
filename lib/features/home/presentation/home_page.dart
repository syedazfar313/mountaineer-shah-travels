import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../models/tour_category.dart';
import '../../../shared/layouts/content_container.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import 'widgets/category_packages_section.dart';
import 'widgets/contact_cta_section.dart';
import 'widgets/destination_showcase_section.dart';
import 'widgets/faq_section.dart';
import 'widgets/featured_destinations_section.dart';
import 'widgets/home_hero.dart';
import 'widgets/offers_section.dart';
import 'widgets/popular_packages_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_choose_us_section.dart';

/// Public homepage.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHero(),
          FeaturedDestinationsSection(),
          PopularPackagesSection(),
          DestinationShowcaseSection(
            title: 'Pakistan Northern Areas',
            subtitle:
                'Mountain valleys, lakes, and old forts in the north of Pakistan.',
            destinationIds: ['gilgit', 'naran-kaghan', 'swat', 'kashmir'],
          ),
          DestinationShowcaseSection(
            background: AppColors.offWhite,
            title: 'International travel',
            subtitle:
                'Holidays and pilgrimages abroad, from the Gulf to Southeast Asia and the Caucasus.',
            destinationIds: [
              'saudi-arabia',
              'malaysia',
              'thailand',
              'azerbaijan',
            ],
          ),
          CategoryPackagesSection(
            title: 'Family holidays and honeymoon packages',
            subtitle:
                'Relaxed itineraries for families and quiet escapes for couples.',
            categories: [TourCategory.family, TourCategory.honeymoon],
          ),
          CategoryPackagesSection(
            background: AppColors.offWhite,
            title: 'Adventure, trekking, and mountaineering tours',
            subtitle:
                'Guided journeys for people who want to get out into the mountains.',
            categories: [TourCategory.adventure, TourCategory.trekking],
          ),
          OffersSection(),
          WhyChooseUsSection(),
          TestimonialsSection(),
          FaqSection(),
          ContactCtaSection(),
          if (kDebugMode) _DeveloperStrip(),
        ],
      ),
    );
  }
}

/// Shown in debug builds only; never part of the released site.
class _DeveloperStrip extends StatelessWidget {
  const _DeveloperStrip();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: ContentContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                'Developer tools (debug builds only)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              AppButton(
                label: 'Open component preview',
                variant: AppButtonVariant.text,
                onPressed: () => context.go(AppRoutes.components),
              ),
            ],
          ),
        ),
      ),
    );
  }
}