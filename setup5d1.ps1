Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\features\home\presentation\widgets\home_section.dart' @'
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/layouts/content_container.dart';
import '../../../../shared/widgets/section_heading.dart';

/// Standard homepage band: coloured background, heading, then content.
class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.background = AppColors.white,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final vertical =
        context.responsive(mobile: 56.0, tablet: 72.0, desktop: 88.0);

    return ColoredBox(
      color: background,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                title: title,
                subtitle: subtitle,
                trailing: trailing,
              ),
              const SizedBox(height: AppSpacing.xl),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
'@

W 'lib\features\home\presentation\widgets\featured_destinations_section.dart' @'
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
'@

W 'lib\features\home\presentation\widgets\popular_packages_section.dart' @'
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

/// Six popular sample packages. Prices and ratings are illustrative.
class PopularPackagesSection extends ConsumerWidget {
  const PopularPackagesSection({super.key});

  static const List<String> _popularIds = [
    'hunza-family-escape',
    'skardu-deosai-adventure',
    'fairy-meadows-trek',
    'kashmir-neelum-honeymoon',
    'dubai-city-and-desert',
    'turkiye-istanbul-cappadocia',
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
          'Sample itineraries for families, couples, groups, and adventurers.',
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
'@

Write-Host ""
$mine = @(
  'lib\features\home\presentation\widgets\home_section.dart',
  'lib\features\home\presentation\widgets\featured_destinations_section.dart',
  'lib\features\home\presentation\widgets\popular_packages_section.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5d1 done."