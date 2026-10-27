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