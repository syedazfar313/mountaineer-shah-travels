import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../models/destination.dart';
import '../../../../repositories/destination_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/destination_card.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// Six hand-picked destinations from the mock repository.
class FeaturedDestinationsSection extends ConsumerWidget {
  const FeaturedDestinationsSection({super.key});

  static const List<String> _featuredIds = [
    'hunza',
    'skardu',
    'fairy-meadows',
    'dubai',
    'turkiye',
    'maldives',
  ];

  // Opens the destinations page with this destination chosen. Milestone 5
  // replaces this with the destination details page.
  void _open(BuildContext context, Destination destination) {
    final uri = Uri(
      path: AppRoutes.destinations,
      queryParameters: {'destination': destination.id},
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = ref.watch(destinationsProvider);

    return HomeSection(
      title: 'Featured destinations',
      subtitle:
          'From the mountain valleys of the north to beaches and cities abroad.',
      trailing: AppButton(
        label: 'All destinations',
        variant: AppButtonVariant.text,
        onPressed: () => context.go(AppRoutes.destinations),
      ),
      child: destinations.when(
        data: (all) {
          final featured = [
            for (final id in _featuredIds) ...all.where((d) => d.id == id),
          ];
          if (featured.isEmpty) {
            return const EmptyView(
              title: 'No destinations yet',
              message: 'Featured destinations will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [
              for (final destination in featured)
                DestinationCard(
                  destination: destination,
                  onTap: () => _open(context, destination),
                ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 240,
          child: LoadingView(message: 'Loading destinations'),
        ),
        error: (error, stackTrace) => ErrorView(
          message: 'Destinations could not be loaded.',
          onRetry: () => ref.invalidate(destinationsProvider),
        ),
      ),
    );
  }
}