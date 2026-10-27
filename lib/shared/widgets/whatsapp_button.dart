import 'package:flutter/material.dart';

import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/responsive.dart';

/// Floating WhatsApp inquiry button. The URL comes from [AppConfig].
class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({super.key});

  void _open(BuildContext context) =>
      openExternalUrl(context, AppConfig.whatsappUrl, label: 'WhatsApp');

  @override
  Widget build(BuildContext context) {
    // heroTag is null so page transitions never see duplicate Hero tags.
    if (context.isMobile) {
      return FloatingActionButton(
        heroTag: null,
        tooltip: 'Chat on WhatsApp',
        backgroundColor: AppColors.success,
        foregroundColor: AppColors.white,
        onPressed: () => _open(context),
        child: const Icon(Icons.chat_bubble_outline),
      );
    }
    return FloatingActionButton.extended(
      heroTag: null,
      tooltip: 'Chat on WhatsApp',
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.white,
      onPressed: () => _open(context),
      icon: const Icon(Icons.chat_bubble_outline),
      label: const Text('WhatsApp us'),
    );
  }
}