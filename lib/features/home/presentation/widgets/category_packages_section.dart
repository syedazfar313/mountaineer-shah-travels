import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/tour_category.dart';
import '../../../../models/tour_package.dart';
import '../../../../repositories/package_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/package_card.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// A homepage band showing sample packages from chosen categories, such as
/// family and honeymoon, or adventure and trekking.
class CategoryPackagesSection extends ConsumerWidget {
  const CategoryPackagesSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.categories,
    this.background = AppColors.white,
  });

  final String title;
  final String subtitle;
  final List<TourCategory> categories;
  final Color background;

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
      background: background,
      title: title,
      subtitle: subtitle,
      child: packages.when(
        data: (all) {
          final shown =
              all.where((p) => categories.contains(p.category)).toList();
          if (shown.isEmpty) {
            return const EmptyView(
              title: 'No packages yet',
              message: 'Packages for this category will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [
              for (final package in shown)
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