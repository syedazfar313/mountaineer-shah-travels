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