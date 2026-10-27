Set-Location $PSScriptRoot

function W($p, $c) {
  $d = Split-Path $p -Parent
  if ($d) { New-Item -ItemType Directory -Force $d | Out-Null }
  $full = Join-Path (Get-Location) $p
  [System.IO.File]::WriteAllText($full, $c, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "written: $p"
}

W 'pubspec.yaml' @'
name: mountaineer_shah_travels
description: Mountaineer Shah Travels - Flutter Web frontend (Phase 1, mock data only).
publish_to: 'none'
version: 0.2.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter
  # State management and dependency injection (swap repositories in Phase 2).
  flutter_riverpod: ^2.5.1
  # Declarative, URL-based routing for Flutter Web.
  go_router: ^14.2.0
  # Brand typefaces (Fraunces for display, Source Sans 3 for body).
  google_fonts: ^6.2.1
  # Opens WhatsApp and social links in a new tab.
  url_launcher: ^6.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
'@

W 'lib\core\routing\app_routes.dart' @'
/// All planned route paths. A path only works once its page is registered in
/// `app_router.dart` (each milestone registers its own routes).
abstract final class AppRoutes {
  // Development only (registered in debug builds)
  static const String components = '/components';

  // Public
  static const String home = '/';
  static const String destinations = '/destinations';
  static const String destinationDetails = '/destinations/:id';
  static const String packages = '/packages';
  static const String packageDetails = '/packages/:id';
  static const String booking = '/booking/:packageId';
  static const String about = '/about';
  static const String gallery = '/gallery';
  static const String reviews = '/reviews';
  static const String contact = '/contact';
  static const String faq = '/faq';
  static const String privacy = '/privacy-policy';
  static const String terms = '/terms-and-conditions';
  static const String cancellation = '/cancellation-policy';

  // Auth (UI demo)
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Customer dashboard (demo)
  static const String dashboard = '/dashboard';
  static const String myBookings = '/dashboard/bookings';
  static const String bookingDetails = '/dashboard/bookings/:id';
  static const String profile = '/dashboard/profile';

  // Admin dashboard (demo)
  static const String admin = '/admin';
  static const String adminDestinations = '/admin/destinations';
  static const String adminPackages = '/admin/packages';
  static const String adminBookings = '/admin/bookings';
  static const String adminOffers = '/admin/offers';
  static const String adminReviews = '/admin/reviews';
}
'@

W 'lib\models\tour_category.dart' @'
/// Tour categories shown in filters and badges.
enum TourCategory {
  family('Family Tours'),
  honeymoon('Honeymoon Packages'),
  group('Group Tours'),
  adventure('Adventure Tours'),
  trekking('Trekking and Mountaineering'),
  luxury('Luxury Holidays'),
  budget('Budget Tours'),
  international('International Holidays');

  const TourCategory(this.label);

  final String label;
}
'@

W 'lib\models\destination.dart' @'
import 'package:flutter/foundation.dart';

enum DestinationRegion {
  pakistan('Pakistan'),
  international('International');

  const DestinationRegion(this.label);

  final String label;
}

@immutable
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    this.galleryUrls = const [],
    this.highlights = const [],
    this.bestSeason,
  });

  final String id;
  final String name;
  final String country;
  final DestinationRegion region;
  final String tagline;
  final String description;

  /// Remote URL today; may become a bundled asset or Firebase Storage URL later.
  final String imageUrl;
  final List<String> galleryUrls;
  final List<String> highlights;
  final String? bestSeason;
}
'@

W 'lib\models\tour_package.dart' @'
import 'package:flutter/foundation.dart';

import 'tour_category.dart';

@immutable
class ItineraryDay {
  const ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
  });

  final int day;
  final String title;
  final String description;
}

@immutable
class TourPackage {
  const TourPackage({
    required this.id,
    required this.name,
    required this.destinationId,
    required this.destinationName,
    required this.description,
    required this.coverImageUrl,
    required this.durationDays,
    required this.price,
    required this.currency,
    required this.priceBasis,
    required this.category,
    this.galleryUrls = const [],
    this.itinerary = const [],
    this.accommodation = '',
    this.transport = '',
    this.included = const [],
    this.excluded = const [],
    this.travelDates = const [],
    this.availabilityNote,
    this.rating,
    this.isSample = true,
  });

  final String id;
  final String name;
  final String destinationId;
  final String destinationName;
  final String description;
  final String coverImageUrl;
  final List<String> galleryUrls;
  final int durationDays;
  final double price;
  final String currency;

  /// For example "per person" or "per couple".
  final String priceBasis;
  final TourCategory category;
  final List<ItineraryDay> itinerary;
  final String accommodation;
  final String transport;
  final List<String> included;
  final List<String> excluded;
  final List<DateTime> travelDates;
  final String? availabilityNote;
  final double? rating;

  /// True while price, rating, and availability are illustrative demo values.
  final bool isSample;
}
'@

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
'@

W 'lib\core\utils\validators.dart' @'
/// Form validators. Each returns an error message, or null when valid.
abstract final class Validators {
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email address is required';
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(text) ? null : 'Enter a valid email address';
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Contact number is required';
    if (!RegExp(r'^[+0-9 ()\-]+$').hasMatch(text)) {
      return 'Use digits, spaces, and + only';
    }
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid contact number';
    }
    return null;
  }
}
'@

W 'lib\core\utils\launcher.dart' @'
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
'@

W 'lib\core\constants\nav_items.dart' @'
import '../routing/app_routes.dart';

class NavItem {
  const NavItem(this.label, this.path);

  final String label;
  final String path;
}

/// Link groups shared by the header, mobile drawer, and footer.
abstract final class AppNav {
  static const List<NavItem> main = [
    NavItem('Home', AppRoutes.home),
    NavItem('Destinations', AppRoutes.destinations),
    NavItem('Packages', AppRoutes.packages),
    NavItem('About', AppRoutes.about),
    NavItem('Gallery', AppRoutes.gallery),
    NavItem('Reviews', AppRoutes.reviews),
    NavItem('Contact', AppRoutes.contact),
  ];

  static const List<NavItem> explore = [
    NavItem('Destinations', AppRoutes.destinations),
    NavItem('Tour Packages', AppRoutes.packages),
    NavItem('Travel Gallery', AppRoutes.gallery),
    NavItem('Reviews', AppRoutes.reviews),
  ];

  static const List<NavItem> support = [
    NavItem('About Us', AppRoutes.about),
    NavItem('Contact Us', AppRoutes.contact),
    NavItem('FAQ', AppRoutes.faq),
    NavItem('Privacy Policy', AppRoutes.privacy),
    NavItem('Terms and Conditions', AppRoutes.terms),
    NavItem('Cancellation Policy', AppRoutes.cancellation),
  ];
}
'@

W 'test\utils_test.dart' @'
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/core/utils/formatters.dart';
import 'package:mountaineer_shah_travels/core/utils/validators.dart';

void main() {
  group('formatters', () {
    test('formatPrice adds thousands separators', () {
      expect(formatPrice(85000, 'PKR'), 'PKR 85,000');
      expect(formatPrice(1234567.4, 'USD'), 'USD 1,234,567');
      expect(formatPrice(950, 'PKR'), 'PKR 950');
    });

    test('formatDuration shows days and nights', () {
      expect(formatDuration(6), '6 days, 5 nights');
      expect(formatDuration(1), '1 day');
    });
  });

  group('validators', () {
    test('required', () {
      expect(Validators.required('  ', field: 'Name'), 'Name is required');
      expect(Validators.required('Ali'), isNull);
    });

    test('email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('traveler@example.com'), isNull);
    });

    test('phone', () {
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('12'), isNotNull);
      expect(Validators.phone('abc12345678'), isNotNull);
      expect(Validators.phone('+92 300 1234567'), isNull);
    });
  });
}
'@

Write-Host ""
Write-Host "Script 1 done. Now run: flutter pub get ; flutter test test\utils_test.dart"