Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\home\presentation\widgets\testimonials_section.dart' @'
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
'@

W 'lib\features\home\presentation\home_page.dart' @'
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
import 'widgets/destination_showcase_section.dart';
import 'widgets/featured_destinations_section.dart';
import 'widgets/home_hero.dart';
import 'widgets/offers_section.dart';
import 'widgets/popular_packages_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_choose_us_section.dart';

/// Public homepage. Sections are added milestone by milestone.
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
      color: AppColors.offWhite,
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
'@

W 'test\home_page_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/shared/widgets/destination_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/package_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/star_rating.dart';

Future<void> _pumpHome(WidgetTester tester) async {
  // Very tall viewport so the whole homepage is on screen without scrolling.
  tester.view.physicalSize = const Size(1000, 20000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapExpect(WidgetTester tester, Finder target, String text) async {
  await tester.tap(target);
  await tester.pumpAndSettle();
  expect(find.textContaining(text), findsOneWidget);
}

void main() {
  testWidgets('hero shows the headline and both calls to action',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text(AppConfig.tagline), findsWidgets);
    expect(find.text('Explore Destinations'), findsOneWidget);
    expect(find.text('Browse Tour Packages'), findsOneWidget);
  });

  testWidgets('Explore Destinations opens the destinations route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('Explore Destinations'), 'Milestone 5');
  });

  testWidgets('Browse Tour Packages opens the packages route', (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('Browse Tour Packages'), 'Milestone 6');
  });

  testWidgets('search in destinations mode goes to destinations',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.widgetWithText(ElevatedButton, 'Search'),
      'Milestone 5',
    );
  });

  testWidgets('search in packages mode goes to packages', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Tour packages'));
    await tester.pumpAndSettle();
    await _tapExpect(
      tester,
      find.widgetWithText(ElevatedButton, 'Search'),
      'Milestone 6',
    );
  });

  testWidgets('home shows every section title', (tester) async {
    await _pumpHome(tester);

    for (final title in const [
      'Featured destinations',
      'Popular tour packages',
      'Pakistan Northern Areas',
      'International travel',
      'Family holidays and honeymoon packages',
      'Adventure, trekking, and mountaineering tours',
      'Seasonal offers',
      'Why choose us',
      'What travelers say',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
  });

  testWidgets('home shows 14 destination cards and 10 package cards',
      (tester) async {
    await _pumpHome(tester);

    expect(find.byType(DestinationCard), findsNWidgets(14));
    expect(find.byType(PackageCard), findsNWidgets(10));
  });

  testWidgets('home shows three clearly labelled sample offers',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Summer in the North'), findsOneWidget);
    expect(find.text('Sample offer, for illustration only.'), findsNWidgets(3));
  });

  testWidgets('home shows three clearly labelled sample testimonials',
      (tester) async {
    await _pumpHome(tester);

    expect(find.byType(StarRating), findsNWidgets(3));
    expect(find.text('Sample review'), findsNWidgets(3));
    expect(find.textContaining('not real customer reviews'), findsOneWidget);
  });

  testWidgets('tapping a featured destination opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    final hunza = find.descendant(
      of: find.byType(DestinationCard),
      matching: find.text('Hunza'),
    );
    await _tapExpect(tester, hunza.first, 'Milestone 5');
  });

  testWidgets('tapping a Pakistan showcase card opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    final gilgit = find.descendant(
      of: find.byType(DestinationCard),
      matching: find.text('Gilgit'),
    );
    await _tapExpect(tester, gilgit.first, 'Milestone 5');
  });

  testWidgets('tapping a package card opens the packages route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.text('Hunza Valley Family Escape'),
      'Milestone 6',
    );
  });

  testWidgets('All destinations button opens the destinations route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('All destinations'), 'Milestone 5');
  });
}
'@

Write-Host ""
$mine = @(
  'lib\features\home\presentation\widgets\testimonials_section.dart',
  'lib\features\home\presentation\home_page.dart',
  'test\home_page_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5f3 done."