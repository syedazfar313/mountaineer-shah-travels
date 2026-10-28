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