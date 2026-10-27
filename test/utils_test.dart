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