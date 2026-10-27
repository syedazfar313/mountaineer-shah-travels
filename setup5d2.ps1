Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\home\presentation\home_page.dart' @'
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/layouts/content_container.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
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
  tester.view.physicalSize = const Size(1000, 5000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
  );
  await tester.pumpAndSettle();
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

    await tester.tap(find.text('Explore Destinations'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 5'), findsOneWidget);
  });

  testWidgets('Browse Tour Packages opens the packages route', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Browse Tour Packages'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 6'), findsOneWidget);
  });

  testWidgets('search in destinations mode goes to destinations',
      (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 5'), findsOneWidget);
  });

  testWidgets('search in packages mode goes to packages', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Tour packages'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 6'), findsOneWidget);
  });

  testWidgets('home shows featured destinations and popular packages',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Featured destinations'), findsOneWidget);
    expect(find.text('Popular tour packages'), findsOneWidget);
    expect(find.byType(DestinationCard), findsNWidgets(6));
    expect(find.byType(PackageCard), findsNWidgets(6));
  });

  testWidgets('tapping a destination card opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    await tester.tap(find
        .descendant(
          of: find.byType(DestinationCard),
          matching: find.text('Hunza'),
        )
        .first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 5'), findsOneWidget);
  });

  testWidgets('tapping a package card opens the packages route',
      (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Hunza Valley Family Escape'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 6'), findsOneWidget);
  });

  testWidgets('All destinations button opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('All destinations'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 5'), findsOneWidget);
  });
}
'@

Write-Host ""
$mine = @(
  'lib\features\home\presentation\home_page.dart',
  'test\home_page_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5d2 done."