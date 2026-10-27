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