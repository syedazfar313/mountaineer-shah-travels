import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  // Clean URLs (/destinations) instead of hash URLs (/#/destinations).
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MountaineerShahApp()));
}
