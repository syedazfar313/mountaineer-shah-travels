import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in a new tab. When no URL is configured yet, explains that
/// this is a demo instead of failing silently.
Future<void> openExternalUrl(
  BuildContext context,
  String url, {
  required String label,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  if (url.isEmpty) {
    messenger.showSnackBar(
      SnackBar(content: Text('$label link is not set up yet. This is a demo.')),
    );
    return;
  }
  final uri = Uri.tryParse(url);
  final opened =
      uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text('Could not open $label.')));
  }
}