import 'package:flutter/material.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import 'home_section.dart';

class _Reason {
  const _Reason(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

const List<_Reason> _reasons = [
  _Reason(
    Icons.tune,
    'Planned around you',
    'Trips shaped to your group, budget, and pace.',
  ),
  _Reason(
    Icons.receipt_long_outlined,
    'Clear itineraries',
    'Day-by-day plans with inclusions and exclusions listed up front.',
  ),
  _Reason(
    Icons.support_agent_outlined,
    'Support when you need it',
    'Questions answered before you book and while you travel.',
  ),
  _Reason(
    Icons.public,
    'Home and abroad',
    'Northern Pakistan, the Gulf, Asia, and Europe from one agency.',
  ),
];

/// Four reasons to book. The wording is sample copy to be replaced with the
/// agency's own details before launch.
class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      background: AppColors.offWhite,
      title: 'Why choose us',
      subtitle: 'What to expect when you plan a trip with ${AppConfig.brandName}.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdaptiveGrid(
            desktopColumns: 4,
            children: [
              for (final reason in _reasons) _ReasonCard(reason: reason),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Sample content. Replace with your own agency details before launch.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reason});

  final _Reason reason;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.forestSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(reason.icon, color: AppColors.forest),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(reason.title, style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              reason.text,
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}