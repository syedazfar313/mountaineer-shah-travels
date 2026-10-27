import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/destination.dart';
import '../../../../repositories/destination_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/destination_card.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// A homepage band showing a hand-picked group of destinations, such as the
/// Pakistan northern areas or international holidays.
class DestinationShowcaseSection extends ConsumerWidget {
  const DestinationShowcaseSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.destinationIds,
    this.background = AppColors.white,
  });

  final String title;
  final String subtitle;
  final List<String> destinationIds;
  final Color background;

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
      background: background,
      title: title,
      subtitle: subtitle,
      child: destinations.when(
        data: (all) {
          final shown = [
            for (final id in destinationIds) ...all.where((d) => d.id == id),
          ];
          if (shown.isEmpty) {
            return const EmptyView(
              title: 'No destinations yet',
              message: 'These destinations will appear here.',
            );
          }
          return AdaptiveGrid(
            desktopColumns: 4,
            children: [
              for (final destination in shown)
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