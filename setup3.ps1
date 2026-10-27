Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\shared\widgets\hover_surface.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Tappable card surface: lifts slightly on hover or keyboard focus and
/// shows a visible focus ring. Motion is skipped when the user prefers it.
class HoverSurface extends StatefulWidget {
  const HoverSurface({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final lifted = _hovered || _focused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return AnimatedContainer(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _focused ? AppColors.forest : AppColors.border,
          width: _focused ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: lifted ? const Color(0x240B3B35) : const Color(0x0F000000),
            blurRadius: lifted ? 24 : 8,
            offset: Offset(0, lifted ? 12 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          child: widget.child,
        ),
      ),
    );
  }
}
'@

W 'lib\shared\widgets\destination_card.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/destination.dart';
import 'app_badge.dart';
import 'app_image.dart';
import 'hover_surface.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  final Destination destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return HoverSurface(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                url: destination.imageUrl,
                aspectRatio: 4 / 3,
                semanticLabel: destination.name,
              ),
              Positioned(
                left: AppSpacing.md - 4,
                top: AppSpacing.md - 4,
                child: AppBadge(
                  label: destination.region.label,
                  tone: BadgeTone.gold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: text.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  destination.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(color: AppColors.muted),
                ),
                if (destination.bestSeason != null) ...[
                  const SizedBox(height: AppSpacing.md - 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 16,
                        color: AppColors.goldDeep,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Best time: ${destination.bestSeason}',
                          style: text.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
'@

W 'lib\shared\widgets\package_card.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../models/tour_package.dart';
import 'app_badge.dart';
import 'app_image.dart';
import 'hover_surface.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package, required this.onTap});

  final TourPackage package;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rating = package.rating;

    return HoverSurface(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                url: package.coverImageUrl,
                semanticLabel: package.name,
              ),
              Positioned(
                left: AppSpacing.md - 4,
                top: AppSpacing.md - 4,
                child: AppBadge(
                  label: package.category.label,
                  tone: BadgeTone.gold,
                ),
              ),
              if (rating != null)
                Positioned(
                  right: AppSpacing.md - 4,
                  top: AppSpacing.md - 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.goldDeep,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: text.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                _MetaRow(
                  icon: Icons.location_on_outlined,
                  label: package.destinationName,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                _MetaRow(
                  icon: Icons.schedule,
                  label: formatDuration(package.durationDays),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'From',
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
                Text(
                  formatPrice(package.price, package.currency),
                  style: text.titleLarge?.copyWith(color: AppColors.forest),
                ),
                Text(
                  package.priceBasis,
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
                if (package.isSample) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sample price and rating, for illustration only.',
                    style: text.labelSmall?.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
'@

W 'lib\shared\widgets\whatsapp_button.dart' @'
import 'package:flutter/material.dart';

import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/responsive.dart';

/// Floating WhatsApp inquiry button. The URL comes from [AppConfig].
class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({super.key});

  void _open(BuildContext context) =>
      openExternalUrl(context, AppConfig.whatsappUrl, label: 'WhatsApp');

  @override
  Widget build(BuildContext context) {
    // heroTag is null so page transitions never see duplicate Hero tags.
    if (context.isMobile) {
      return FloatingActionButton(
        heroTag: null,
        tooltip: 'Chat on WhatsApp',
        backgroundColor: AppColors.success,
        foregroundColor: AppColors.white,
        onPressed: () => _open(context),
        child: const Icon(Icons.chat_bubble_outline),
      );
    }
    return FloatingActionButton.extended(
      heroTag: null,
      tooltip: 'Chat on WhatsApp',
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.white,
      onPressed: () => _open(context),
      icon: const Icon(Icons.chat_bubble_outline),
      label: const Text('WhatsApp us'),
    );
  }
}
'@

W 'lib\shared\layouts\adaptive_grid.dart' @'
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/responsive.dart';

/// Grid whose column count adapts to screen size. Cards in the same row are
/// stretched to equal height.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = AppSpacing.lg,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final slice = children.sublist(i, math.min(i + columns, children.length));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < columns; j++) ...[
                if (j > 0) SizedBox(width: spacing),
                Expanded(
                  child: j < slice.length ? slice[j] : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          rows[i],
        ],
      ],
    );
  }
}
'@

Write-Host ""
Write-Host "Script 3 done."