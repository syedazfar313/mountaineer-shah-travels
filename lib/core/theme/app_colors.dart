import 'package:flutter/material.dart';

/// Brand color tokens. Gold fails contrast on white as text: use [goldDeep]
/// for gold-toned text on light surfaces and [gold] on forest backgrounds.
abstract final class AppColors {
  static const Color forest = Color(0xFF0B3B35);
  static const Color forestDeep = Color(0xFF072622);
  static const Color forestSoft = Color(0xFFE4EEEC);
  static const Color gold = Color(0xFFD7A86E);
  static const Color goldDeep = Color(0xFF8A5E24);
  static const Color goldLine = Color(0x80D7A86E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F6F1);
  static const Color charcoal = Color(0xFF232928);
  static const Color muted = Color(0xFF59615F);
  static const Color border = Color(0xFFE3DFD5);
  static const Color error = Color(0xFFB3261E);
  static const Color success = Color(0xFF1E7B4F);
}
