Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'test\widget_test.dart' @'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/core/utils/responsive.dart';

void main() {
  testWidgets('app boots and shows brand name and tagline', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
    );
    await tester.pumpAndSettle();

    // Brand and tagline also appear in the header and footer.
    expect(find.text(AppConfig.brandName), findsWidgets);
    expect(find.text(AppConfig.tagline), findsWidgets);
  });

  test('breakpoints map widths to screen sizes', () {
    expect(Breakpoints.fromWidth(375), ScreenSize.mobile);
    expect(Breakpoints.fromWidth(768), ScreenSize.tablet);
    expect(Breakpoints.fromWidth(1200), ScreenSize.desktop);
    expect(Breakpoints.fromWidth(1920), ScreenSize.wide);
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
        matching: find.text('Destinations'),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Milestone 5'), findsOneWidget);
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
  'test\widget_test.dart',
  'test\shared_components_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 300) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 4c done."