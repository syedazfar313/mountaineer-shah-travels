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