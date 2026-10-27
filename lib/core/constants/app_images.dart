/// One place for every image reference, so remote URLs can later be swapped
/// for bundled assets or Firebase Storage URLs without touching any widget.
///
/// An empty string means "no image yet": widgets then show a branded
/// fallback. To add a photo, put its URL here (or in the maps, keyed by id).
abstract final class AppImages {
  /// Homepage hero photo. Empty shows the drawn mountain ridge instead.
  static const String hero = '';

  static const Map<String, String> _destinations = {
    // 'hunza': 'https://...',
  };

  static const Map<String, String> _packages = {
    // 'hunza-family-escape': 'https://...',
  };

  static String destination(String id) => _destinations[id] ?? '';

  static String package(String id) => _packages[id] ?? '';
}