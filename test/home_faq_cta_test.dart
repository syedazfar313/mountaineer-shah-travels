import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/mock_data/mock_faqs.dart';

Future<void> _pumpHome(WidgetTester tester) async {
  // Very tall viewport so the whole homepage is on screen without scrolling.
  tester.view.physicalSize = const Size(1000, 20000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('FAQ shows five questions with answers hidden at first',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Frequently asked questions'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNWidgets(5));
    expect(find.text(mockFaqs.first.answer), findsNothing);
  });

  testWidgets('tapping a question reveals its answer', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text(mockFaqs.first.question));
    await tester.pumpAndSettle();

    expect(find.text(mockFaqs.first.answer), findsOneWidget);
  });

  testWidgets('View all FAQs opens the FAQ route', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('View all FAQs'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 11'), findsOneWidget);
  });

  testWidgets('Get in touch opens the contact route', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Get in touch'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Milestone 11'), findsOneWidget);
  });

  testWidgets('WhatsApp button explains the link is not set up yet',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Ready to plan your trip?'), findsOneWidget);
    await tester.tap(find.text('Message us on WhatsApp'));
    await tester.pump();

    expect(find.textContaining('not set up yet'), findsOneWidget);
  });
}