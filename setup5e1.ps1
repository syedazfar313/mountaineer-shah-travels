Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\home\presentation\widgets\destination_showcase_section.dart' @'
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
'@

W 'lib\features\home\presentation\widgets\category_packages_section.dart' @'
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
'@

Write-Host ""
$mine = @(
  'lib\features\home\presentation\widgets\destination_showcase_section.dart',
  'lib\features\home\presentation\widgets\category_packages_section.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5e1 done."