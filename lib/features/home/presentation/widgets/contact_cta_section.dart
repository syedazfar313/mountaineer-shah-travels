import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/launcher.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/layouts/content_container.dart';
import '../../../../shared/widgets/app_button.dart';

/// Closing call to action above the footer.
class ContactCtaSection extends StatelessWidget {
  const ContactCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final headlineStyle = context.responsive(
      mobile: text.headlineMedium,
      tablet: text.headlineLarge,
      desktop: text.displaySmall,
    );
    final vertical =
        context.responsive(mobile: 56.0, tablet: 72.0, desktop: 88.0);

    return ColoredBox(
      color: AppColors.forestSoft,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: Column(
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Ready to plan your trip?',
                  textAlign: TextAlign.center,
                  style: headlineStyle?.copyWith(color: AppColors.forest),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Tell us where you want to go and who is travelling. This is a demo site, so no real enquiries are sent yet.',
                  textAlign: TextAlign.center,
                  style: text.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  AppButton(
                    label: 'Get in touch',
                    icon: Icons.mail_outline,
                    onPressed: () => context.go(AppRoutes.contact),
                  ),
                  AppButton(
                    label: 'Message us on WhatsApp',
                    icon: Icons.chat_bubble_outline,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => openExternalUrl(
                      context,
                      AppConfig.whatsappUrl,
                      label: 'WhatsApp',
                    ),
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