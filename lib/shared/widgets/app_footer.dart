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