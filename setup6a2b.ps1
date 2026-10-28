Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'test\home_page_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/shared/widgets/destination_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/package_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/star_rating.dart';

const _destinationsTitle = 'Explore our destinations';

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

  testWidgets('Explore Destinations opens the destinations page',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.text('Explore Destinations'),
      _destinationsTitle,
    );
  });

  testWidgets('Browse Tour Packages opens the packages route', (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('Browse Tour Packages'), 'Milestone 6');
  });

  testWidgets('search in destinations mode opens the destinations page',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.widgetWithText(ElevatedButton, 'Search'),
      _destinationsTitle,
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

  testWidgets('tapping a featured destination opens its details route',
      (tester) async {
    await _pumpHome(tester);

    final hunza = find.descendant(
      of: find.byType(DestinationCard),
      matching: find.text('Hunza'),
    );
    await _tapExpect(tester, hunza.first, 'Milestone 5');
  });

  testWidgets('tapping a Pakistan showcase card opens its details route',
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

  testWidgets('All destinations button opens the destinations page',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('All destinations'), _destinationsTitle);
  });
}
'@

W 'test\shared_components_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/theme/app_theme.dart';
import 'package:mountaineer_shah_travels/models/tour_category.dart';
import 'package:mountaineer_shah_travels/models/tour_package.dart';
import 'package:mountaineer_shah_travels/shared/widgets/app_button.dart';
import 'package:mountaineer_shah_travels/shared/widgets/app_header.dart';
import 'package:mountaineer_shah_travels/shared/widgets/package_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/state_views.dart';

const _package = TourPackage(
  id: 'test',
  name: 'Test Valley Escape',
  destinationId: 'test-dest',
  destinationName: 'Test Valley',
  description: 'Test description.',
  coverImageUrl: '',
  durationDays: 6,
  price: 85000,
  currency: 'PKR',
  priceBasis: 'per person',
  category: TourCategory.family,
  rating: 4.7,
);

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(useGoogleFonts: false),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Center(child: SizedBox(width: 380, child: child)),
      ),
    ),
  );
}

void main() {
  group('AppButton', () {
    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Go', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('is disabled while loading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Go', isLoading: true, onPressed: () => taps++)),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      expect(taps, 0);
    });
  });

  group('PackageCard', () {
    testWidgets('shows name, price, duration, and sample note', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(PackageCard(package: _package, onTap: () => taps++)),
      );

      expect(find.text('Test Valley Escape'), findsOneWidget);
      expect(find.text('PKR 85,000'), findsOneWidget);
      expect(find.text('6 days, 5 nights'), findsOneWidget);
      expect(find.textContaining('for illustration only'), findsOneWidget);

      await tester.tap(find.text('Test Valley Escape'));
      expect(taps, 1);
    });
  });

  group('State views', () {
    testWidgets('EmptyView runs its action', (tester) async {
      var cleared = 0;
      await tester.pumpWidget(
        _wrap(EmptyView(
          title: 'Nothing here',
          message: 'Try again.',
          actionLabel: 'Clear filters',
          onAction: () => cleared++,
        )),
      );
      await tester.tap(find.text('Clear filters'));
      expect(cleared, 1);
    });

    testWidgets('ErrorView offers retry', (tester) async {
      var retries = 0;
      await tester.pumpWidget(
        _wrap(ErrorView(message: 'Failed.', onRetry: () => retries++)),
      );
      await tester.tap(find.text('Try again'));
      expect(retries, 1);
    });
  });

  group('Navigation', () {
    testWidgets('wide header link opens the matching page', (tester) async {
      // Wide enough for inline nav even with the test font's wide glyphs.
      tester.view.physicalSize = const Size(2400, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
        of: find.byType(AppHeader),
        matching: find.text('Packages'),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Milestone 6'), findsOneWidget);
    });

    testWidgets('narrow screen opens the menu drawer', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open menu'));
      await tester.pumpAndSettle();

      expect(find.text('Plan a trip'), findsOneWidget);
    });
  });
}
'@

Write-Host ""
$mine = @(
  'test\home_page_test.dart',
  'test\shared_components_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 6a2b done."