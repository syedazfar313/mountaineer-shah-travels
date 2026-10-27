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