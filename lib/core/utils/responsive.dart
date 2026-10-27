import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop, wide }

abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double wide = 1440;

  static ScreenSize fromWidth(double width) {
    if (width >= wide) return ScreenSize.wide;
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}

extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize => Breakpoints.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktopOrWider =>
      screenSize == ScreenSize.desktop || screenSize == ScreenSize.wide;

  /// Picks a value for the current size, falling back to the next smaller one.
  T responsive<T>({required T mobile, T? tablet, T? desktop, T? wide}) {
    switch (screenSize) {
      case ScreenSize.wide:
        return wide ?? desktop ?? tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.mobile:
        return mobile;
    }
  }

  /// Horizontal page gutter.
  double get pagePadding => responsive(mobile: 20.0, tablet: 32.0, desktop: 48.0);
}
