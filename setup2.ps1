Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'lib\shared\widgets\app_image.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'mountain_logo.dart';

/// Network image with a loading tint and a branded fallback. An empty [url]
/// or a failed request both show the fallback, so layouts never break.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 10,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String url;
  final double aspectRatio;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? const _ImageFallback()
        : Image.network(
            url,
            fit: fit,
            semanticLabel: semanticLabel,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const ColoredBox(color: AppColors.forestSoft),
            errorBuilder: (context, error, stackTrace) =>
                const _ImageFallback(),
          );
    return AspectRatio(aspectRatio: aspectRatio, child: image);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.forestSoft,
      child: Center(
        child: MountainLogo(size: 64, color: Color(0xFF9DB8B3)),
      ),
    );
  }
}
'@

W 'lib\shared\widgets\app_button.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppButtonVariant { primary, gold, secondary, outlineLight, text }

/// Single button entry point so every screen shares the same look.
/// Set [onPressed] to null to disable. [outlineLight] is for dark backgrounds.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  Color get _spinnerColor => switch (variant) {
        AppButtonVariant.primary => AppColors.white,
        AppButtonVariant.outlineLight => AppColors.white,
        AppButtonVariant.gold => AppColors.forestDeep,
        _ => AppColors.forest,
      };

  @override
  Widget build(BuildContext context) {
    final VoidCallback? handler = isLoading ? null : onPressed;

    final Widget content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: _spinnerColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    final Widget button = switch (variant) {
      AppButtonVariant.primary =>
        ElevatedButton(onPressed: handler, child: content),
      AppButtonVariant.gold => ElevatedButton(
          onPressed: handler,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.forestDeep,
          ),
          child: content,
        ),
      AppButtonVariant.secondary =>
        OutlinedButton(onPressed: handler, child: content),
      AppButtonVariant.outlineLight => OutlinedButton(
          onPressed: handler,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.white, width: 1.5),
          ),
          child: content,
        ),
      AppButtonVariant.text => TextButton(onPressed: handler, child: content),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
'@

W 'lib\shared\widgets\app_badge.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum BadgeTone { neutral, gold, success }

/// Small pill label for categories, regions, and status.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.neutral,
    this.icon,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (tone) {
      BadgeTone.neutral => (AppColors.forestSoft, AppColors.forest),
      BadgeTone.gold => (AppColors.gold, AppColors.forestDeep),
      BadgeTone.success => (const Color(0xFFDFF3E8), AppColors.success),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: foreground),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@

W 'lib\shared\widgets\section_heading.dart' @'
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
'@

W 'lib\shared\widgets\app_inputs.dart' @'
import 'package:flutter/material.dart';

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

/// Labeled text field with validation, used by every form.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.autofillHints,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: obscureText ? 1 : maxLines,
          obscureText: obscureText,
          onChanged: onChanged,
          autofillHints: autofillHints,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Labeled dropdown with validation.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.validator,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? hint;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

/// Search box for destination and package lists.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: hint,
      textField: true,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
'@

W 'lib\shared\widgets\state_views.dart' @'
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.leading,
    required this.title,
    this.message,
    this.action,
  });

  final Widget leading;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading,
              const SizedBox(height: AppSpacing.md),
              Text(title, textAlign: TextAlign.center, style: text.titleLarge),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: AppColors.muted),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.lg),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle(this.icon, this.color, this.background);

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Loading'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: _StateLayout(
        leading: const SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(color: AppColors.forest),
        ),
        title: message,
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      leading: const _IconCircle(
        Icons.error_outline,
        AppColors.error,
        Color(0xFFFBE9E7),
      ),
      title: title,
      message: message,
      action: onRetry == null
          ? null
          : AppButton(
              label: 'Try again',
              variant: AppButtonVariant.secondary,
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      leading: _IconCircle(icon, AppColors.forest, AppColors.forestSoft),
      title: title,
      message: message,
      action: (actionLabel == null || onAction == null)
          ? null
          : AppButton(
              label: actionLabel!,
              variant: AppButtonVariant.secondary,
              onPressed: onAction,
            ),
    );
  }
}
'@

Write-Host ""
Write-Host "Script 2 done."