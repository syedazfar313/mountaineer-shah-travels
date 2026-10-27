Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\home\presentation\widgets\popular_packages_section.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/tour_package.dart';
import '../../../../repositories/package_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/package_card.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// Popular sample packages. Family, honeymoon, adventure, and trekking
/// packages have their own homepage sections, so they are not repeated here.
/// Prices and ratings are illustrative.
class PopularPackagesSection extends ConsumerWidget {
  const PopularPackagesSection({super.key});

  static const List<String> _popularIds = [
    'dubai-city-and-desert',
    'turkiye-istanbul-cappadocia',
    'swat-kalam-group',
    'karakoram-luxury-circuit',
    'naran-kaghan-budget',
  ];

  // Opens the packages page with this package chosen. Milestone 6 replaces
  // this with the package details page.
  void _open(BuildContext context, TourPackage package) {
    final uri = Uri(
      path: AppRoutes.packages,
      queryParameters: {'package': package.id},
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(packagesProvider);

    return HomeSection(
      background: AppColors.offWhite,
      title: 'Popular tour packages',
      subtitle:
          'Sample group departures, luxury circuits, budget trips, and international holidays.',
      trailing: AppButton(
        label: 'All packages',
        variant: AppButtonVariant.text,
        onPressed: () => context.go(AppRoutes.packages),
      ),
      child: packages.when(
        data: (all) {
          final popular = [
            for (final id in _popularIds) ...all.where((p) => p.id == id),
          ];
          if (popular.isEmpty) {
            return const EmptyView(
              title: 'No packages yet',
              message: 'Popular packages will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [
              for (final package in popular)
                PackageCard(
                  package: package,
                  onTap: () => _open(context, package),
                ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 240,
          child: LoadingView(message: 'Loading packages'),
        ),
        error: (error, stackTrace) => ErrorView(
          message: 'Packages could not be loaded.',
          onRetry: () => ref.invalidate(packagesProvider),
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
import 'widgets/popular_packages_section.dart';

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
'@

W 'test\home_page_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/shared/widgets/destination_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/package_card.dart';

Future<void> _pumpHome(WidgetTester tester) async {
  // Very tall viewport so the whole homepage is on screen without scrolling.
  tester.view.physicalSize = const Size(1000, 16000);
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
  'lib\features\home\presentation\widgets\popular_packages_section.dart',
  'lib\features\home\presentation\home_page.dart',
  'test\home_page_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5e2 done."