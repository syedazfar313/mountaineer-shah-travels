import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/destinations/presentation/destinations_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/showcase/presentation/component_showcase_page.dart';
import '../../shared/widgets/not_found_page.dart';
import '../../shared/widgets/planned_page.dart';
import 'app_routes.dart';

/// Pages that exist in the plan but are built in a later milestone. Each is
/// replaced by its real route when that milestone lands.
const List<({String path, String title, int milestone})> _plannedPages = [
  (
    path: AppRoutes.destinationDetails,
    title: 'Destination details',
    milestone: 5,
  ),
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
      GoRoute(
        path: AppRoutes.destinations,
        name: 'destinations',
        // Links such as /destinations?destination=hunza open that
        // destination's details instead of the list.
        redirect: (context, state) {
          final id = state.uri.queryParameters['destination'];
          if (id != null && id.isNotEmpty) {
            return '${AppRoutes.destinations}/$id';
          }
          return null;
        },
        builder: (context, state) => const DestinationsPage(),
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