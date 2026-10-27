import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/responsive.dart';

/// Section title with optional subtitle and trailing action (e.g. "View all").
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.centered = false,
    this.onDark = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool centered;
  final bool onDark;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final titleStyle = context.responsive(
      mobile: text.headlineMedium,
      tablet: text.headlineLarge,
      desktop: text.displaySmall,
    );
    final align = centered ? TextAlign.center : TextAlign.start;

    final column = Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: align,
            style: titleStyle?.copyWith(
              color: onDark ? AppColors.white : AppColors.forest,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm + 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: align,
              style: text.bodyLarge?.copyWith(
                color: onDark ? AppColors.offWhite : AppColors.muted,
              ),
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return column;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: column),
        const SizedBox(width: AppSpacing.md),
        trailing!,
      ],
    );
  }
}