import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/shared/widgets/destination_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/package_card.dart';
import 'package:mountaineer_shah_travels/shared/widgets/star_rating.dart';

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

Future<void> _tapExpect(WidgetTester tester, Finder target, String text) async {
  await tester.tap(target);
  await tester.pumpAndSettle();
  expect(find.textContaining(text), findsOneWidget);
}

void main() {
  testWidgets('hero shows the headline and both calls to action',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text(AppConfig.tagline), findsWidgets);
    expect(find.text('Explore Destinations'), findsOneWidget);
    expect(find.text('Browse Tour Packages'), findsOneWidget);
  });

  testWidgets('Explore Destinations opens the destinations route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('Explore Destinations'), 'Milestone 5');
  });

  testWidgets('Browse Tour Packages opens the packages route', (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('Browse Tour Packages'), 'Milestone 6');
  });

  testWidgets('search in destinations mode goes to destinations',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.widgetWithText(ElevatedButton, 'Search'),
      'Milestone 5',
    );
  });

  testWidgets('search in packages mode goes to packages', (tester) async {
    await _pumpHome(tester);

    await tester.tap(find.text('Tour packages'));
    await tester.pumpAndSettle();
    await _tapExpect(
      tester,
      find.widgetWithText(ElevatedButton, 'Search'),
      'Milestone 6',
    );
  });

  testWidgets('home shows every section title', (tester) async {
    await _pumpHome(tester);

    for (final title in const [
      'Featured destinations',
      'Popular tour packages',
      'Pakistan Northern Areas',
      'International travel',
      'Family holidays and honeymoon packages',
      'Adventure, trekking, and mountaineering tours',
      'Seasonal offers',
      'Why choose us',
      'What travelers say',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
  });

  testWidgets('home shows 14 destination cards and 10 package cards',
      (tester) async {
    await _pumpHome(tester);

    expect(find.byType(DestinationCard), findsNWidgets(14));
    expect(find.byType(PackageCard), findsNWidgets(10));
  });

  testWidgets('home shows three clearly labelled sample offers',
      (tester) async {
    await _pumpHome(tester);

    expect(find.text('Summer in the North'), findsOneWidget);
    expect(find.text('Sample offer, for illustration only.'), findsNWidgets(3));
  });

  testWidgets('home shows three clearly labelled sample testimonials',
      (tester) async {
    await _pumpHome(tester);

    expect(find.byType(StarRating), findsNWidgets(3));
    expect(find.text('Sample review'), findsNWidgets(3));
    expect(find.textContaining('not real customer reviews'), findsOneWidget);
  });

  testWidgets('tapping a featured destination opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    final hunza = find.descendant(
      of: find.byType(DestinationCard),
      matching: find.text('Hunza'),
    );
    await _tapExpect(tester, hunza.first, 'Milestone 5');
  });

  testWidgets('tapping a Pakistan showcase card opens the destinations route',
      (tester) async {
    await _pumpHome(tester);

    final gilgit = find.descendant(
      of: find.byType(DestinationCard),
      matching: find.text('Gilgit'),
    );
    await _tapExpect(tester, gilgit.first, 'Milestone 5');
  });

  testWidgets('tapping a package card opens the packages route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(
      tester,
      find.text('Hunza Valley Family Escape'),
      'Milestone 6',
    );
  });

  testWidgets('All destinations button opens the destinations route',
      (tester) async {
    await _pumpHome(tester);
    await _tapExpect(tester, find.text('All destinations'), 'Milestone 5');
  });
}