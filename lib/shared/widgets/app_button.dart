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