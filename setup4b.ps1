Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\core\routing\app_router.dart' @'
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/showcase/presentation/component_showcase_page.dart';
import '../../shared/widgets/not_found_page.dart';
import '../../shared/widgets/planned_page.dart';
import 'app_routes.dart';

/// Pages that exist in the plan but are built in a later milestone. Each is
/// replaced by its real route when that milestone lands.
const List<({String path, String title, int milestone})> _plannedPages = [
  (path: AppRoutes.destinations, title: 'Destinations', milestone: 5),
  (path: AppRoutes.packages, title: 'Tour Packages', milestone: 6),
  (path: AppRoutes.login, title: 'Log in', milestone: 8),
  (path: AppRoutes.register, title: 'Create account', milestone: 8),
  (path: AppRoutes.forgotPassword, title: 'Forgot password', milestone: 8),
  (path: AppRoutes.dashboard, title: 'Dashboard', milestone: 9),
  (path: AppRoutes.myBookings, title: 'My bookings', milestone: 9),
  (path: AppRoutes.profile, title: 'Profile', milestone: 9),
  (path: AppRoutes.admin, title: 'Admin overview', milestone: 10),
  (path: AppRoutes.adminDestinations, title: 'Manage destinations', milestone: 10),
  (path: AppRoutes.adminPackages, title: 'Manage tour packages', milestone: 10),
  (path: AppRoutes.adminBookings, title: 'Manage bookings', milestone: 10),
  (path: AppRoutes.adminOffers, title: 'Manage offers', milestone: 10),
  (path: AppRoutes.adminReviews, title: 'Manage reviews', milestone: 10),
  (path: AppRoutes.about, title: 'About Us', milestone: 11),
  (path: AppRoutes.gallery, title: 'Travel Gallery', milestone: 11),
  (path: AppRoutes.reviews, title: 'Reviews', milestone: 11),
  (path: AppRoutes.contact, title: 'Contact Us', milestone: 11),
  (path: AppRoutes.faq, title: 'FAQ', milestone: 11),
  (path: AppRoutes.privacy, title: 'Privacy Policy', milestone: 11),
  (path: AppRoutes.terms, title: 'Terms and Conditions', milestone: 11),
  (path: AppRoutes.cancellation, title: 'Cancellation Policy', milestone: 11),
];

/// Central router. Provided via Riverpod so it can later react to auth state.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.components,
          builder: (context, state) => const ComponentShowcasePage(),
        ),
      for (final page in _plannedPages)
        GoRoute(
          path: page.path,
          builder: (context, state) =>
              PlannedPage(title: page.title, milestone: page.milestone),
        ),
    ],
    errorBuilder: (context, state) =>
        NotFoundPage(location: state.uri.toString()),
  );
});
'@

W 'lib\features\home\presentation\home_page.dart' @'
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/mountain_logo.dart';

/// Milestone 3 shell: shows the shared header and footer around a temporary
/// hero block. The full homepage replaces this in Milestone 4.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final logoSize = context.responsive(mobile: 72.0, tablet: 96.0, desktop: 112.0);

    return PageScaffold(
      body: ColoredBox(
        color: AppColors.forest,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 520),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(context.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MountainLogo(size: logoSize, color: AppColors.offWhite),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AppConfig.brandName,
                      textAlign: TextAlign.center,
                      style: text.displaySmall?.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppConfig.tagline,
                      textAlign: TextAlign.center,
                      style: text.titleMedium?.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Shared components are ready. The full homepage is built in the next milestone.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: AppColors.offWhite),
                    ),
                    if (kDebugMode) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Open component preview',
                        variant: AppButtonVariant.outlineLight,
                        onPressed: () => context.go(AppRoutes.components),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
'@

W 'lib\features\showcase\presentation\component_showcase_page.dart' @'
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../models/destination.dart';
import '../../../models/tour_category.dart';
import '../../../models/tour_package.dart';
import '../../../shared/layouts/adaptive_grid.dart';
import '../../../shared/layouts/content_container.dart';
import '../../../shared/layouts/page_scaffold.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_inputs.dart';
import '../../../shared/widgets/destination_card.dart';
import '../../../shared/widgets/package_card.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/state_views.dart';

// Preview-only data. Real mock data arrives in Milestones 5 and 6.
const _previewDestinations = [
  Destination(
    id: 'preview-hunza',
    name: 'Hunza',
    country: 'Pakistan',
    region: DestinationRegion.pakistan,
    tagline: 'Orchards, old forts, and glacier-fed valleys beneath the Karakoram.',
    description: 'Preview description.',
    imageUrl: '',
    bestSeason: 'April to October',
  ),
  Destination(
    id: 'preview-dubai',
    name: 'Dubai',
    country: 'United Arab Emirates',
    region: DestinationRegion.international,
    tagline: 'Skyline views, desert evenings, and world-class shopping.',
    description: 'Preview description.',
    imageUrl: '',
    bestSeason: 'November to March',
  ),
];

const _previewPackage = TourPackage(
  id: 'preview-package',
  name: 'Hunza Valley Family Escape',
  destinationId: 'preview-hunza',
  destinationName: 'Hunza',
  description: 'Preview description.',
  coverImageUrl: '',
  durationDays: 6,
  price: 85000,
  currency: 'PKR',
  priceBasis: 'per person',
  category: TourCategory.family,
  rating: 4.7,
);

/// Debug-only page that shows every shared component in one place.
class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _search = TextEditingController();
  TourCategory? _category;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _search.dispose();
    super.dispose();
  }

  void _say(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _validate() {
    final ok = _formKey.currentState?.validate() ?? false;
    _say(ok
        ? 'Form is valid (preview only, nothing is saved).'
        : 'Please fix the highlighted fields.');
  }

  void _simulateLoading() {
    setState(() => _loading = true);
    unawaited(Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _loading = false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: ContentContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBadge(label: 'Development preview', tone: BadgeTone.gold),
              const SizedBox(height: AppSpacing.md),
              const SectionHeading(
                title: 'Component preview',
                subtitle:
                    'Every shared component in one place. Visible in debug builds only. All data here is illustrative.',
              ),
              _block('Buttons', _buttons()),
              _block('Badges', _badges()),
              _block('Form inputs', _form()),
              _block('Loading, error, and empty states', _states()),
              _block(
                'Cards',
                AdaptiveGrid(
                  children: [
                    for (final d in _previewDestinations)
                      DestinationCard(
                        destination: d,
                        onTap: () => _say('${d.name} tapped (preview only).'),
                      ),
                    PackageCard(
                      package: _previewPackage,
                      onTap: () => _say('Package tapped (preview only).'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _block(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buttons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            AppButton(label: 'Primary', onPressed: () => _say('Primary pressed')),
            AppButton(
              label: 'Gold',
              variant: AppButtonVariant.gold,
              onPressed: () => _say('Gold pressed'),
            ),
            AppButton(
              label: 'Secondary',
              variant: AppButtonVariant.secondary,
              onPressed: () => _say('Secondary pressed'),
            ),
            AppButton(
              label: 'Text button',
              variant: AppButtonVariant.text,
              onPressed: () => _say('Text pressed'),
            ),
            AppButton(
              label: 'With icon',
              icon: Icons.explore_outlined,
              onPressed: () => _say('Icon button pressed'),
            ),
            AppButton(
              label: 'Show loading',
              isLoading: _loading,
              onPressed: _simulateLoading,
            ),
            const AppButton(label: 'Disabled', onPressed: null),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: AppButton(
            label: 'Outline on dark',
            variant: AppButtonVariant.outlineLight,
            onPressed: () => _say('Outline pressed'),
          ),
        ),
      ],
    );
  }

  Widget _badges() {
    return const Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppBadge(label: 'Neutral'),
        AppBadge(label: 'Featured', tone: BadgeTone.gold, icon: Icons.star),
        AppBadge(label: 'Confirmed', tone: BadgeTone.success, icon: Icons.check),
      ],
    );
  }

  Widget _form() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSearchField(
              hint: 'Search destinations',
              controller: _search,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Full name',
              controller: _name,
              prefixIcon: Icons.person_outline,
              validator: (v) => Validators.required(v, field: 'Full name'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Email address',
              controller: _email,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.md),
            AppDropdownField<TourCategory>(
              label: 'Tour category',
              hint: 'Choose a category',
              value: _category,
              items: [
                for (final c in TourCategory.values)
                  DropdownMenuItem(value: c, child: Text(c.label)),
              ],
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Choose a category' : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Validate form', onPressed: _validate),
          ],
        ),
      ),
    );
  }

  Widget _states() {
    Widget framed(Widget child) => SizedBox(
          width: 340,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: child,
          ),
        );

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [
        framed(const LoadingView(message: 'Loading packages')),
        framed(
          ErrorView(
            message: 'Packages could not be loaded. Check your connection and try again.',
            onRetry: () => _say('Retry pressed (preview only).'),
          ),
        ),
        framed(
          EmptyView(
            title: 'No packages found',
            message: 'Try a different category or clear your search.',
            actionLabel: 'Clear filters',
            onAction: () => _say('Clear filters pressed (preview only).'),
          ),
        ),
      ],
    );
  }
}
'@

Write-Host ""
$mine = @(
  'lib\core\routing\app_router.dart',
  'lib\features\home\presentation\home_page.dart',
  'lib\features\showcase\presentation\component_showcase_page.dart'
)
foreach ($f in $mine) {
  if (-not (Test-Path $f)) { Write-Host "PROBLEM (missing): $f" }
  elseif ((Get-Item $f).Length -lt 500) { Write-Host "PROBLEM (too small): $f" }
  else { Write-Host ("OK  {0}  {1} bytes" -f $f, (Get-Item $f).Length) }
}
Write-Host ""
Write-Host "Script 4b done."