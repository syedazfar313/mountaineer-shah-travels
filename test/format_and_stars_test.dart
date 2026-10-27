import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/core/utils/formatters.dart';
import 'package:mountaineer_shah_travels/shared/widgets/star_rating.dart';

void main() {
  test('formatMonthYear writes the month name and year', () {
    expect(formatMonthYear(DateTime(2027, 8, 31)), 'August 2027');
    expect(formatMonthYear(DateTime(2027, 1, 1)), 'January 2027');
  });

  testWidgets('StarRating shows five stars and a spoken label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StarRating(rating: 4.5))),
    );

    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.bySemanticsLabel('4.5 out of 5 stars'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('StarRating shows empty stars for a low rating', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StarRating(rating: 2))),
    );

    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_border), findsNWidgets(3));
  });
}