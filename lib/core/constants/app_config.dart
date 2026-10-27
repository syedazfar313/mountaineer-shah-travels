/// Central, configurable app values. Nothing here is a real business contact.
///
/// Override at build/run time, e.g.:
/// `flutter run -d chrome --dart-define=WHATSAPP_URL=https://wa.me/<number>`
abstract final class AppConfig {
  static const String brandName = 'Mountaineer Shah Travels';
  static const String tagline = 'Discover the World. Experience the Extraordinary.';

  static const String whatsappUrl =
      String.fromEnvironment('WHATSAPP_URL', defaultValue: '');
  static const String facebookUrl =
      String.fromEnvironment('FACEBOOK_URL', defaultValue: '');
  static const String instagramUrl =
      String.fromEnvironment('INSTAGRAM_URL', defaultValue: '');
  static const String youtubeUrl =
      String.fromEnvironment('YOUTUBE_URL', defaultValue: '');
  static const String tiktokUrl =
      String.fromEnvironment('TIKTOK_URL', defaultValue: '');

  static bool get hasWhatsapp => whatsappUrl.isNotEmpty;
}
