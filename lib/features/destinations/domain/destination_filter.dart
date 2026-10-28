import '../../../models/destination.dart';

String _normalize(String text) => text.toLowerCase().replaceAll('\u00FC', 'u');

/// Filters destinations by search text and region. Kept as a plain function
/// so it can be tested without any widgets.
List<Destination> filterDestinations(
  List<Destination> all, {
  String query = '',
  DestinationRegion? region,
}) {
  final needle = _normalize(query.trim());

  return all.where((destination) {
    if (region != null && destination.region != region) return false;
    if (needle.isEmpty) return true;

    final haystack = _normalize(
      [
        destination.name,
        destination.country,
        destination.tagline,
        ...destination.highlights,
      ].join(' '),
    );
    return haystack.contains(needle);
  }).toList();
}