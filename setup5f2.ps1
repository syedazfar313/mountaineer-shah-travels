Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\core\utils\formatters.dart' @'
/// Formats [amount] with thousands separators, e.g. "PKR 85,000".
String formatPrice(num amount, String currency) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$currency $buffer';
}

/// "6 days, 5 nights" (or "1 day" for day trips).
String formatDuration(int days) {
  if (days <= 1) return '1 day';
  return '$days days, ${days - 1} nights';
}

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "August 2027".
String formatMonthYear(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.year}';
'@

W 'lib\shared\widgets\star_rating.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Row of five stars for a rating from 0 to 5, with half-star steps.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  IconData _iconFor(int position) {
    if (rating >= position) return Icons.star;
    if (rating >= position - 0.5) return Icons.star_half;
    return Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${rating.toStringAsFixed(1)} out of 5 stars',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(_iconFor(i), size: size, color: AppColors.goldDeep),
          ],
        ),
      ),
    );
  }
}
'@

W 'lib\features\home\presentation\widgets\offers_section.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../models/offer.dart';
import '../../../../repositories/offer_providers.dart';
import '../../../../shared/layouts/adaptive_grid.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/state_views.dart';
import 'home_section.dart';

/// Seasonal promotions. All offers here are illustrative samples.
class OffersSection extends ConsumerWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);

    return HomeSection(
      title: 'Seasonal offers',
      subtitle:
          'Sample promotions for illustration. These discounts and dates are not real offers.',
      child: offers.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyView(
              title: 'No offers right now',
              message: 'Seasonal offers will appear here.',
            );
          }
          return AdaptiveGrid(
            children: [for (final offer in list) _OfferCard(offer: offer)],
          );
        },
        loading: () => const SizedBox(
          height: 240,
          child: LoadingView(message: 'Loading offers'),
        ),
        error: (error, stackTrace) => ErrorView(
          message: 'Offers could not be loaded.',
          onRetry: () => ref.invalidate(offersProvider),
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBadge(label: offer.season, tone: BadgeTone.gold),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${offer.discountPercent}% off',
              style: text.displaySmall?.copyWith(color: AppColors.gold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              offer.title,
              style: text.titleLarge?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              offer.description,
              style: text.bodyMedium?.copyWith(color: AppColors.offWhite),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Valid until ${formatMonthYear(offer.validUntil)}',
              style: text.bodySmall?.copyWith(color: AppColors.gold),
            ),
            if (offer.isSample)
              Text(
                'Sample offer, for illustration only.',
                style: text.labelSmall?.copyWith(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.w400,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Browse packages',
              variant: AppButtonVariant.outlineLight,
              onPressed: () => context.go(AppRoutes.packages),
            ),
          ],
        ),
      ),
    );
  }
}
'@

W 'lib\features\home\presentation\widgets\why_choose_us_section.dart' @'
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
'@

W 'test\format_and_stars_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/core/utils/formatters.dart';
import 'package:mountaineer_shah_travels/shared/widgets/star_rating.dart';

void main() {
  test('formatMonthYear writes the month name and year', () {
    expect(formatMonthYear(DateTime(2027, 8, 31)), 'August 2027');
    expect(formatMonthYear(DateTime(2027, 1, 1)), 'January 2027');
  });

  testWidgets('StarRating shows five stars and a spoken label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StarRating(rating: 4.5))),
    );

    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.bySemanticsLabel('4.5 out of 5 stars'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('StarRating shows empty stars for a low rating', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StarRating(rating: 2))),
    );

    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_border), findsNWidgets(3));
  });
}
'@

Write-Host ""
$mine = @(
  'lib\core\utils\formatters.dart',
  'lib\shared\widgets\star_rating.dart',
  'lib\features\home\presentation\widgets\offers_section.dart',
  'lib\features\home\presentation\widgets\why_choose_us_section.dart',
  'test\format_and_stars_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5f2 done."