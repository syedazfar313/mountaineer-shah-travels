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