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