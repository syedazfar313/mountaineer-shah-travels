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