import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type scale. Fraunces (display serif) carries the brand; Source Sans 3 keeps
/// body text and forms legible. Fallback families are used when fonts are off.
abstract final class AppTypography {
  static TextStyle _display(double size, bool gf, {FontWeight w = FontWeight.w600}) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: w,
      height: 1.15,
      letterSpacing: -0.4,
      color: AppColors.charcoal,
    );
    return gf ? GoogleFonts.fraunces(textStyle: base) : base.copyWith(fontFamily: 'serif');
  }

  static TextStyle _body(double size, bool gf,
      {FontWeight w = FontWeight.w400, double h = 1.5}) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: w,
      height: h,
      color: AppColors.charcoal,
    );
    return gf ? GoogleFonts.sourceSans3(textStyle: base) : base;
  }

  static TextTheme textTheme({required bool useGoogleFonts}) {
    final g = useGoogleFonts;
    return TextTheme(
      displayLarge: _display(64, g),
      displayMedium: _display(48, g),
      displaySmall: _display(36, g),
      headlineLarge: _display(32, g),
      headlineMedium: _display(28, g),
      headlineSmall: _display(24, g),
      titleLarge: _body(20, g, w: FontWeight.w700, h: 1.3),
      titleMedium: _body(17, g, w: FontWeight.w600, h: 1.4),
      titleSmall: _body(15, g, w: FontWeight.w600, h: 1.4),
      bodyLarge: _body(18, g, h: 1.6),
      bodyMedium: _body(16, g),
      bodySmall: _body(14, g),
      labelLarge: _body(16, g, w: FontWeight.w600, h: 1.2),
      labelMedium: _body(14, g, w: FontWeight.w600, h: 1.2),
      labelSmall: _body(12, g, w: FontWeight.w600, h: 1.2),
    );
  }
}
