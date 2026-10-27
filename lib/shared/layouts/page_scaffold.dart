import 'package:flutter/material.dart';

import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/whatsapp_button.dart';

/// Standard public page frame: fixed header, scrolling body + footer, and the
/// WhatsApp button. Every public page should be wrapped in this.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
    this.showWhatsApp = true,
  });

  final Widget body;
  final bool showFooter;
  final bool showWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppNavDrawer(),
      floatingActionButton: showWhatsApp ? const WhatsAppButton() : null,
      body: Column(
        children: [
          const SafeArea(bottom: false, child: AppHeader()),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  body,
                  if (showFooter) const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}