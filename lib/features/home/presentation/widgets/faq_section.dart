import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../mock_data/mock_faqs.dart';
import '../../../../models/faq_item.dart';
import '../../../../shared/widgets/app_button.dart';
import 'home_section.dart';

/// Homepage FAQ accordion. Shows the first few questions and links to the
/// full FAQ page. Answers are sample content.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  static const int _shown = 5;

  @override
  Widget build(BuildContext context) {
    final items = mockFaqs.take(_shown).toList();

    return HomeSection(
      background: AppColors.offWhite,
      title: 'Frequently asked questions',
      subtitle:
          'Sample answers for illustration. Replace them with real agency policies before launch.',
      trailing: AppButton(
        label: 'View all FAQs',
        variant: AppButtonVariant.text,
        onPressed: () => context.go(AppRoutes.faq),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [for (final item in items) _FaqTile(item: item)],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 4,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              expandedAlignment: Alignment.centerLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              iconColor: AppColors.forest,
              collapsedIconColor: AppColors.forest,
              title: Text(item.question, style: text.titleMedium),
              children: [
                Text(
                  item.answer,
                  style: text.bodyMedium?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}