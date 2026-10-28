Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\destinations\domain\destination_filter.dart' @'
import '../../../models/destination.dart';

String _normalize(String text) => text.toLowerCase().replaceAll('\u00FC', 'u');

/// Filters destinations by search text and region. Kept as a plain function
/// so it can be tested without any widgets.
List<Destination> filterDestinations(
  List<Destination> all, {
  String query = '',
  DestinationRegion? region,
}) {
  final needle = _normalize(query.trim());

  return all.where((destination) {
    if (region != null && destination.region != region) return false;
    if (needle.isEmpty) return true;

    final haystack = _normalize(
      [
        destination.name,
        destination.country,
        destination.tagline,
        ...destination.highlights,
      ].join(' '),
    );
    return haystack.contains(needle);
  }).toList();
}
'@

W 'lib\features\destinations\presentation\destinations_page.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../models/destination.dart';
import '../../../repositories/destination_providers.dart';
import '../../../shared/layouts/adaptive_grid.dart';
import '../../../shared/layouts/content_container.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_inputs.dart';
import '../../../shared/widgets/destination_card.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/state_views.dart';
import '../domain/destination_filter.dart';

/// Lists every destination with search and a region filter.
class DestinationsPage extends ConsumerStatefulWidget {
  const DestinationsPage({super.key});

  @override
  ConsumerState<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends ConsumerState<DestinationsPage> {
  final _search = TextEditingController();
  DestinationRegion? _region;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _search.clear();
      _region = null;
    });
  }

  void _open(Destination destination) {
    context.go('${AppRoutes.destinations}/${destination.id}');
  }

  @override
  Widget build(BuildContext context) {
    final destinations = ref.watch(destinationsProvider);
    final vertical =
        context.responsive(mobile: 40.0, tablet: 56.0, desktop: 72.0);

    return PageScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: AppColors.forest,
            child: ContentContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: vertical),
                child: const SectionHeading(
                  title: 'Explore our destinations',
                  subtitle:
                      'Browse places across Pakistan and abroad. Search by name or filter by region.',
                  onDark: true,
                ),
              ),
            ),
          ),
          ContentContainer(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters(context),
                    const SizedBox(height: AppSpacing.lg),
                    destinations.when(
                      data: _buildResults,
                      loading: () => const SizedBox(
                        height: 240,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final search = AppSearchField(
      hint: 'Search destinations',
      controller: _search,
      onChanged: (_) => setState(() {}),
    );
    final chips = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _chip('All', null),
        _chip('Pakistan', DestinationRegion.pakistan),
        _chip('International', DestinationRegion.international),
      ],
    );

    if (context.isDesktopOrWider) {
      return Row(
        children: [
          Expanded(child: search),
          const SizedBox(width: AppSpacing.lg),
          chips,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        search,
        const SizedBox(height: AppSpacing.md),
        chips,
      ],
    );
  }

  Widget _chip(String label, DestinationRegion? region) {
    final selected = _region == region;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColors.forest,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.border),
      labelStyle: TextStyle(
        color: selected ? AppColors.white : AppColors.charcoal,
      ),
      onSelected: (_) => setState(() => _region = region),
    );
  }

  Widget _buildResults(List<Destination> all) {
    final shown = filterDestinations(
      all,
      query: _search.text,
      region: _region,
    );

    if (shown.isEmpty) {
      return EmptyView(
        title: 'No destinations found',
        message: 'Try a different name or clear the filters.',
        actionLabel: 'Clear filters',
        onAction: _clearFilters,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            shown.length == 1 ? '1 destination' : '${shown.length} destinations',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AdaptiveGrid(
          desktopColumns: 4,
          children: [
            for (final destination in shown)
              DestinationCard(
                destination: destination,
                onTap: () => _open(destination),
              ),
          ],
        ),
      ],
    );
  }
}
'@

W 'test\destination_filter_test.dart' @'
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/features/destinations/domain/destination_filter.dart';
import 'package:mountaineer_shah_travels/models/destination.dart';
import 'package:mountaineer_shah_travels/repositories/mock_destination_repository.dart';

void main() {
  late List<Destination> all;

  setUp(() async {
    all = await const MockDestinationRepository().getAll();
  });

  test('no filters returns every destination', () {
    expect(filterDestinations(all).length, all.length);
  });

  test('region filter splits Pakistan and international', () {
    final pakistan =
        filterDestinations(all, region: DestinationRegion.pakistan);
    final international =
        filterDestinations(all, region: DestinationRegion.international);

    expect(pakistan.length, 8);
    expect(international.length, 8);
  });

  test('name search ignores case', () {
    final result = filterDestinations(all, query: 'HUNZA');

    expect(result.length, 1);
    expect(result.first.id, 'hunza');
  });

  test('search ignores accents so turkiye finds T\u00FCrkiye', () {
    final result = filterDestinations(all, query: 'turkiye');

    expect(result.length, 1);
    expect(result.first.id, 'turkiye');
  });

  test('search also matches highlights', () {
    final result = filterDestinations(all, query: 'attabad');

    expect(result.map((d) => d.id), contains('hunza'));
  });

  test('region and search combine', () {
    final result = filterDestinations(
      all,
      query: 'hunza',
      region: DestinationRegion.international,
    );

    expect(result, isEmpty);
  });

  test('a search with no match returns an empty list', () {
    expect(filterDestinations(all, query: 'zzzz'), isEmpty);
  });
}
'@

Write-Host ""
$mine = @(
  'lib\features\destinations\domain\destination_filter.dart',
  'lib\features\destinations\presentation\destinations_page.dart',
  'test\destination_filter_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 6a1 done."