Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\shared\widgets\app_header.dart' @'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/nav_items.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'app_button.dart';
import 'mountain_logo.dart';

bool _isActive(String current, String path) =>
    path == AppRoutes.home ? current == path : current.startsWith(path);

/// Top bar. Shows inline links on wide screens and a menu button otherwise.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  /// Below this width the seven links plus actions no longer fit.
  static const double inlineNavMinWidth = 1280;

  @override
  Widget build(BuildContext context) {
    final inline = MediaQuery.sizeOf(context).width >= inlineNavMinWidth;
    final current = GoRouterState.of(context).matchedLocation;

    return Material(
      color: AppColors.white,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          height: inline ? 76 : 64,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.pagePadding),
            child: inline
                ? Row(
                    children: [
                      const _BrandLink(),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final item in AppNav.main)
                                _NavLink(
                                  item: item,
                                  active: _isActive(current, item.path),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text('Log in'),
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        label: 'Plan a trip',
                        variant: AppButtonVariant.gold,
                        onPressed: () => context.go(AppRoutes.packages),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _BrandLink(),
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          tooltip: 'Open menu',
                          iconSize: 28,
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _BrandLink extends StatelessWidget {
  const _BrandLink();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.go(AppRoutes.home),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MountainLogo(size: 38),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                AppConfig.brandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20,
                      color: AppColors.forest,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item, required this.active});

  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? AppColors.gold : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: active ? AppColors.forest : AppColors.charcoal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () => context.go(item.path),
        child: Text(item.label),
      ),
    );
  }
}

/// Slide-out menu used by [AppHeader] on narrow screens.
class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({super.key});

  void _go(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  const MountainLogo(size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppConfig.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close menu',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  for (final item in AppNav.main)
                    ListTile(
                      title: Text(item.label),
                      selected: _isActive(current, item.path),
                      selectedColor: AppColors.forest,
                      selectedTileColor: AppColors.forestSoft,
                      onTap: () => _go(context, item.path),
                    ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Log in'),
                    onTap: () => _go(context, AppRoutes.login),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add_alt),
                    title: const Text('Create account'),
                    onTap: () => _go(context, AppRoutes.register),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'Plan a trip',
                variant: AppButtonVariant.gold,
                expand: true,
                onPressed: () => _go(context, AppRoutes.packages),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@

W 'lib\shared\widgets\app_footer.dart' @'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/responsive.dart';
import '../layouts/content_container.dart';
import 'app_button.dart';
import 'mountain_logo.dart';

/// Multi-column footer: 4 columns on desktop, wrapped blocks elsewhere.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final columns = <Widget>[
      const _FooterBrand(),
      const _FooterLinks(title: 'Explore', items: AppNav.explore),
      const _FooterLinks(title: 'Support', items: AppNav.support),
      const _FooterConnect(),
    ];

    return ColoredBox(
      color: AppColors.forest,
      child: ContentContainer(
        child: Padding(
          padding: const EdgeInsets.only(top: 64, bottom: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (context.isDesktopOrWider)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: columns[0]),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(child: columns[1]),
                    Expanded(child: columns[2]),
                    Expanded(child: columns[3]),
                  ],
                )
              else
                Wrap(
                  spacing: AppSpacing.xxl,
                  runSpacing: AppSpacing.xl + 8,
                  children: [
                    for (final column in columns)
                      SizedBox(width: 280, child: column),
                  ],
                ),
              const SizedBox(height: AppSpacing.xxl),
              const Divider(color: AppColors.goldLine, height: 1),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: AppSpacing.sm,
                spacing: AppSpacing.lg,
                children: [
                  Text(
                    '\u00A9 ${DateTime.now().year} ${AppConfig.brandName}. All rights reserved.',
                    style: text.bodySmall?.copyWith(color: AppColors.offWhite),
                  ),
                  Text(
                    'Demo website: sample content only. No real bookings or payments.',
                    style: text.bodySmall?.copyWith(color: AppColors.gold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const MountainLogo(size: 40, color: AppColors.offWhite),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                AppConfig.brandName,
                style: text.headlineSmall
                    ?.copyWith(fontSize: 20, color: AppColors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppConfig.tagline,
          style: text.titleSmall?.copyWith(color: AppColors.gold),
        ),
        const SizedBox(height: AppSpacing.sm + 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text(
            'Domestic and international journeys, from the valleys of the north to destinations around the world.',
            style: text.bodyMedium?.copyWith(color: AppColors.offWhite),
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.title, required this.items});

  final String title;
  final List<NavItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.gold),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final item in items)
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.offWhite,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 8),
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => context.go(item.path),
            child: Text(item.label),
          ),
      ],
    );
  }
}

class _FooterConnect extends StatelessWidget {
  const _FooterConnect();

  @override
  Widget build(BuildContext context) {
    final socials = <(String, IconData, String)>[
      ('Facebook', Icons.facebook, AppConfig.facebookUrl),
      ('Instagram', Icons.camera_alt_outlined, AppConfig.instagramUrl),
      ('YouTube', Icons.smart_display_outlined, AppConfig.youtubeUrl),
      ('TikTok', Icons.music_note_outlined, AppConfig.tiktokUrl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.gold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          children: [
            for (final (label, icon, url) in socials)
              IconButton(
                tooltip: label,
                color: AppColors.offWhite,
                icon: Icon(icon),
                onPressed: () => openExternalUrl(context, url, label: label),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Chat on WhatsApp',
          variant: AppButtonVariant.outlineLight,
          icon: Icons.chat_bubble_outline,
          onPressed: () => openExternalUrl(
            context,
            AppConfig.whatsappUrl,
            label: 'WhatsApp',
          ),
        ),
      ],
    );
  }
}
'@

W 'lib\shared\layouts\page_scaffold.dart' @'
import 'package:flutter/material.dart';

import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/whatsapp_button.dart';

/// Standard public page frame: fixed header, scrolling body + footer, and the
/// WhatsApp button. Every public page should be wrapped in this.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
    this.showWhatsApp = true,
  });

  final Widget body;
  final bool showFooter;
  final bool showWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppNavDrawer(),
      floatingActionButton: showWhatsApp ? const WhatsAppButton() : null,
      body: Column(
        children: [
          const SafeArea(bottom: false, child: AppHeader()),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  body,
                  if (showFooter) const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'@

W 'lib\shared\widgets\planned_page.dart' @'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../layouts/content_container.dart';
import '../layouts/page_scaffold.dart';
import 'app_badge.dart';
import 'app_button.dart';
import 'section_heading.dart';

/// Honest stand-in for a page scheduled for a later milestone. Keeps header
/// and footer links working until the real page replaces it.
class PlannedPage extends StatelessWidget {
  const PlannedPage({super.key, required this.title, required this.milestone});

  final String title;
  final int milestone;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: ContentContainer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBadge(label: 'Not built yet'),
                const SizedBox(height: AppSpacing.md),
                SectionHeading(
                  title: title,
                  subtitle:
                      'This page is built in Milestone $milestone of the frontend plan.',
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Back to home',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
'@

Write-Host ""
$mine = @(
  'lib\shared\widgets\app_header.dart',
  'lib\shared\widgets\app_footer.dart',
  'lib\shared\layouts\page_scaffold.dart',
  'lib\shared\widgets\planned_page.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 200) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 4a done."