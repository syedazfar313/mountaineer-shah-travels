Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\models\faq_item.dart' @'
import 'package:flutter/foundation.dart';

/// One question and answer. Phase 1 answers are illustrative samples.
@immutable
class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}
'@

W 'lib\mock_data\mock_faqs.dart' @'
import '../models/faq_item.dart';

/// Sample FAQ content for Phase 1. Replace with the agency's real policies.
const List<FaqItem> mockFaqs = [
  FaqItem(
    id: 'choose-package',
    question: 'How do I choose the right package?',
    answer:
        'Start with the category that fits your group, such as family, honeymoon, or trekking, then compare duration and what is included. Each package lists its itinerary day by day.',
  ),
  FaqItem(
    id: 'customize',
    question: 'Can a trip be customized?',
    answer:
        'In this sample, packages are fixed itineraries. A real agency could explain here how it adjusts dates, hotels, or activities on request.',
  ),
  FaqItem(
    id: 'flights-visas',
    question: 'Are flights and visas included?',
    answer:
        'In the sample international packages, airfare and visa fees are listed under Excluded. Check the Included and Excluded lists on each package before you decide.',
  ),
  FaqItem(
    id: 'best-season',
    question: 'When is the best time to visit northern Pakistan?',
    answer:
        'Most northern destinations are easiest to visit from about April to October. Each destination lists its own best season.',
  ),
  FaqItem(
    id: 'demo-bookings',
    question: 'Does this site take real bookings or payments?',
    answer:
        'No. This is a demonstration website. No booking is submitted and no payment is processed.',
  ),
  FaqItem(
    id: 'cancellations',
    question: 'How do cancellations work?',
    answer:
        'Real terms will be published on the Cancellation Policy page. The text on this demo site is sample content only.',
  ),
];
'@

W 'lib\features\home\presentation\widgets\faq_section.dart' @'
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
'@

W 'lib\features\home\presentation\widgets\contact_cta_section.dart' @'
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
'@

W 'lib\features\home\presentation\home_page.dart' @'
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../models/tour_category.dart';
import '../../../shared/layouts/content_container.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import 'widgets/category_packages_section.dart';
import 'widgets/contact_cta_section.dart';
import 'widgets/destination_showcase_section.dart';
import 'widgets/faq_section.dart';
import 'widgets/featured_destinations_section.dart';
import 'widgets/home_hero.dart';
import 'widgets/offers_section.dart';
import 'widgets/popular_packages_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/why_choose_us_section.dart';

/// Public homepage.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHero(),
          FeaturedDestinationsSection(),
          PopularPackagesSection(),
          DestinationShowcaseSection(
            title: 'Pakistan Northern Areas',
            subtitle:
                'Mountain valleys, lakes, and old forts in the north of Pakistan.',
            destinationIds: ['gilgit', 'naran-kaghan', 'swat', 'kashmir'],
          ),
          DestinationShowcaseSection(
            background: AppColors.offWhite,
            title: 'International travel',
            subtitle:
                'Holidays and pilgrimages abroad, from the Gulf to Southeast Asia and the Caucasus.',
            destinationIds: [
              'saudi-arabia',
              'malaysia',
              'thailand',
              'azerbaijan',
            ],
          ),
          CategoryPackagesSection(
            title: 'Family holidays and honeymoon packages',
            subtitle:
                'Relaxed itineraries for families and quiet escapes for couples.',
            categories: [TourCategory.family, TourCategory.honeymoon],
          ),
          CategoryPackagesSection(
            background: AppColors.offWhite,
            title: 'Adventure, trekking, and mountaineering tours',
            subtitle:
                'Guided journeys for people who want to get out into the mountains.',
            categories: [TourCategory.adventure, TourCategory.trekking],
          ),
          OffersSection(),
          WhyChooseUsSection(),
          TestimonialsSection(),
          FaqSection(),
          ContactCtaSection(),
          if (kDebugMode) _DeveloperStrip(),
        ],
      ),
    );
  }
}

/// Shown in debug builds only; never part of the released site.
class _DeveloperStrip extends StatelessWidget {
  const _DeveloperStrip();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: ContentContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                'Developer tools (debug builds only)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              AppButton(
                label: 'Open component preview',
                variant: AppButtonVariant.text,
                onPressed: () => context.go(AppRoutes.components),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@

W 'test\home_faq_cta_test.dart' @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/mock_data/mock_faqs.dart';

Future<void> _pumpHome(WidgetTester tester) async {
  // Very tall viewport so the whole homepage is on screen without scrolling.
  tester.view.physicalSize = const Size(1000, 20000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('FAQ shows five questions with answers hidden at first',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Frequently asked questions'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNWidgets(5));
    expect(find.text(mockFaqs.first.answer), findsNothing);
  });

  testWidgets('tapping a question reveals its answer', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text(mockFaqs.first.question));
    await tester.pumpAndSettle();

    expect(find.text(mockFaqs.first.answer), findsOneWidget);
  });

  testWidgets('View all FAQs opens the FAQ route', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('View all FAQs'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 11'), findsOneWidget);
  });

  testWidgets('Get in touch opens the contact route', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Get in touch'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 11'), findsOneWidget);
  });

  testWidgets('WhatsApp button explains the link is not set up yet',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Ready to plan your trip?'), findsOneWidget);
    await tester.tap(find.text('Message us on WhatsApp'));
    await tester.pump();

    expect(find.textContaining('not set up yet'), findsOneWidget);
  });
}
'@

Write-Host ""
$mine = @(
  'lib\models\faq_item.dart',
  'lib\mock_data\mock_faqs.dart',
  'lib\features\home\presentation\widgets\faq_section.dart',
  'lib\features\home\presentation\widgets\contact_cta_section.dart',
  'lib\features\home\presentation\home_page.dart',
  'test\home_faq_cta_test.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 150) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 5g done."