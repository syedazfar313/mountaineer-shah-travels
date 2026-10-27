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