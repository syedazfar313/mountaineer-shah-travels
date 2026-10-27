Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\core\constants\app_images.dart' @'
/// One place for every image reference, so remote URLs can later be swapped
/// for bundled assets or Firebase Storage URLs without touching any widget.
///
/// An empty string means "no image yet": widgets then show a branded
/// fallback. To add a photo, put its URL here (or in the maps, keyed by id).
abstract final class AppImages {
  /// Homepage hero photo. Empty shows the drawn mountain ridge instead.
  static const String hero = '';

  static const Map<String, String> _destinations = {
    // 'hunza': 'https://...',
  };

  static const Map<String, String> _packages = {
    // 'hunza-family-escape': 'https://...',
  };

  static String destination(String id) => _destinations[id] ?? '';

  static String package(String id) => _packages[id] ?? '';
}
'@

W 'lib\features\home\presentation\widgets\hero_ridge.dart' @'
import 'package:flutter/material.dart';

/// Decorative mountain ridgeline used behind the hero when no photo is set.
class HeroRidge extends StatelessWidget {
  const HeroRidge({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: CustomPaint(painter: _RidgePainter()),
    );
  }
}

class _RidgePainter extends CustomPainter {
  const _RidgePainter();

  static const List<Offset> _back = [
    Offset(0, 0.74),
    Offset(0.10, 0.58),
    Offset(0.18, 0.66),
    Offset(0.30, 0.46),
    Offset(0.42, 0.64),
    Offset(0.55, 0.52),
    Offset(0.68, 0.68),
    Offset(0.80, 0.54),
    Offset(0.92, 0.66),
    Offset(1, 0.60),
  ];

  static const List<Offset> _middle = [
    Offset(0, 0.84),
    Offset(0.12, 0.70),
    Offset(0.24, 0.80),
    Offset(0.38, 0.64),
    Offset(0.50, 0.78),
    Offset(0.64, 0.66),
    Offset(0.78, 0.80),
    Offset(0.90, 0.70),
    Offset(1, 0.78),
  ];

  static const List<Offset> _front = [
    Offset(0, 0.92),
    Offset(0.15, 0.82),
    Offset(0.30, 0.90),
    Offset(0.48, 0.80),
    Offset(0.66, 0.90),
    Offset(0.82, 0.82),
    Offset(1, 0.90),
  ];

  void _fill(Canvas canvas, Size size, List<Offset> ridge, Color color) {
    final path = Path()..moveTo(0, size.height);
    for (final point in ridge) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.2),
      36,
      Paint()..color = const Color(0x2ED7A86E),
    );
    _fill(canvas, size, _back, const Color(0xFF12483F));
    _fill(canvas, size, _middle, const Color(0xFF0F423A));
    _fill(canvas, size, _front, const Color(0xFF0D3D37));
  }

  @override
  bool shouldRepaint(_RidgePainter oldDelegate) => false;
}
'@

W 'lib\features\home\presentation\widgets\hero_search_panel.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../models/destination.dart';
import '../../../../models/tour_category.dart';
import '../../../../repositories/destination_providers.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_inputs.dart';
import '../../../../shared/widgets/state_views.dart';

enum _SearchMode { destinations, packages }

/// Hero search card. The list pages read the chosen filters from the URL
/// (for example /packages?destination=hunza&category=family).
class HeroSearchPanel extends ConsumerStatefulWidget {
  const HeroSearchPanel({super.key});

  @override
  ConsumerState<HeroSearchPanel> createState() => _HeroSearchPanelState();
}

class _HeroSearchPanelState extends ConsumerState<HeroSearchPanel> {
  _SearchMode _mode = _SearchMode.destinations;
  String? _destinationId;
  TourCategory? _category;

  void _search() {
    final params = <String, String>{};
    if (_destinationId != null) params['destination'] = _destinationId!;
    if (_mode == _SearchMode.packages && _category != null) {
      params['category'] = _category!.name;
    }
    final path = _mode == _SearchMode.destinations
        ? AppRoutes.destinations
        : AppRoutes.packages;
    final uri = Uri(
      path: path,
      queryParameters: params.isEmpty ? null : params,
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final destinations = ref.watch(destinationsProvider);
    final padding =
        context.responsive(mobile: 16.0, tablet: 24.0, desktop: 28.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<_SearchMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  foregroundColor: AppColors.forest,
                  selectedBackgroundColor: AppColors.forest,
                  selectedForegroundColor: AppColors.white,
                ),
                segments: const [
                  ButtonSegment(
                    value: _SearchMode.destinations,
                    label: Text('Destinations'),
                    icon: Icon(Icons.place_outlined),
                  ),
                  ButtonSegment(
                    value: _SearchMode.packages,
                    label: Text('Tour packages'),
                    icon: Icon(Icons.card_travel_outlined),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) =>
                    setState(() => _mode = selection.first),
              ),
            ),
            const SizedBox(height: 16),
            destinations.when(
              data: _buildFields,
              loading: () => const SizedBox(
                height: 160,
                child: LoadingView(message: 'Loading destinations'),
              ),
              error: (error, stackTrace) => ErrorView(
                message: 'Destinations could not be loaded.',
                onRetry: () => ref.invalidate(destinationsProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFields(List<Destination> list) {
    final destinationField = AppDropdownField<String?>(
      label: 'Destination',
      hint: 'Any destination',
      value: _destinationId,
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Any destination'),
        ),
        for (final destination in list)
          DropdownMenuItem<String?>(
            value: destination.id,
            child: Text(destination.name),
          ),
      ],
      onChanged: (value) => setState(() => _destinationId = value),
    );

    final categoryField = AppDropdownField<TourCategory?>(
      label: 'Category',
      hint: 'Any category',
      value: _category,
      items: [
        const DropdownMenuItem<TourCategory?>(
          value: null,
          child: Text('Any category'),
        ),
        for (final category in TourCategory.values)
          DropdownMenuItem<TourCategory?>(
            value: category,
            child: Text(category.label),
          ),
      ],
      onChanged: (value) => setState(() => _category = value),
    );

    final showCategory = _mode == _SearchMode.packages;

    if (context.isDesktopOrWider) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: destinationField),
          if (showCategory) ...[
            const SizedBox(width: 16),
            Expanded(child: categoryField),
          ],
          const SizedBox(width: 16),
          AppButton(
            label: 'Search',
            icon: Icons.search,
            onPressed: _search,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        destinationField,
        if (showCategory) ...[
          const SizedBox(height: 16),
          categoryField,
        ],
        const SizedBox(height: 20),
        AppButton(
          label: 'Search',
          icon: Icons.search,
          expand: true,
          onPressed: _search,
        ),
      ],
    );
  }
}
'@

W 'lib\features\home\presentation\widgets\home_hero.dart' @'
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
'@

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
import 'widgets/home_hero.dart';

/// Public homepage. Sections are added milestone by milestone.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeHero(),
          if (kDebugMode) const _DeveloperStrip(),
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

Future<void> _pumpHome(WidgetTester tester) async {
  // Tall viewport so the whole hero is on screen without scrolling.
  tester.view.physicalSize = const Size(1000, 2400);
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
}
'@

Write-Host ""
$mine = @(
  'lib\core\constants\app_images.dart',
  'lib\features\home\presentation\widgets\hero_ridge.dart',
  'lib\features\home\presentation\widgets\hero_search_panel.dart',
  'lib\features\home\presentation\widgets\home_hero.dart',
  'lib\features\home\presentation\home_page.dart',
  'test\home_page_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5c done."