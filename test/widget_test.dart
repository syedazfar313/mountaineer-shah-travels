import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mountaineer_shah_travels/app.dart';
import 'package:mountaineer_shah_travels/core/constants/app_config.dart';
import 'package:mountaineer_shah_travels/core/utils/responsive.dart';

void main() {
  testWidgets('app boots and shows brand name and tagline', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MountaineerShahApp(useGoogleFonts: false)),
    );
    await tester.pumpAndSettle();

    // Brand and tagline also appear in the header and footer.
    expect(find.text(AppConfig.brandName), findsWidgets);
    expect(find.text(AppConfig.tagline), findsWidgets);
  });

  test('breakpoints map widths to screen sizes', () {
    expect(Breakpoints.fromWidth(375), ScreenSize.mobile);
    expect(Breakpoints.fromWidth(768), ScreenSize.tablet);
    expect(Breakpoints.fromWidth(1200), ScreenSize.desktop);
    expect(Breakpoints.fromWidth(1920), ScreenSize.wide);
  });
}