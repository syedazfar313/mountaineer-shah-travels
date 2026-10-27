import 'package:flutter/material.dart';

import '../../core/constants/app_config.dart';
import '../../core/theme/app_colors.dart';

/// Mountain-ridge brand mark: a main peak with a gold snowcap, a lighter
/// companion peak, and a gold ground line.
class MountainLogo extends StatelessWidget {
  const MountainLogo({
    super.key,
    this.size = 40,
    this.color = AppColors.forest,
    this.accent = AppColors.gold,
  });

  final double size;
  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${AppConfig.brandName} logo',
      image: true,
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.square(size),
          painter: _MountainPainter(color: color, accent: accent),
        ),
      ),
    );
  }
}

class _MountainPainter extends CustomPainter {
  _MountainPainter({required this.color, required this.accent});

  final Color color;
  final Color accent;

  Path _polygon(Size s, List<Offset> unitPoints) {
    final path = Path()
      ..moveTo(unitPoints.first.dx * s.width, unitPoints.first.dy * s.height);
    for (final p in unitPoints.skip(1)) {
      path.lineTo(p.dx * s.width, p.dy * s.height);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final companion = Paint()..color = Color.lerp(color, AppColors.gold, 0.35)!;
    final main = Paint()..color = color;
    final cap = Paint()..color = accent;

    final rightPeak = _polygon(size, const [
      Offset(0.46, 0.88),
      Offset(0.72, 0.42),
      Offset(0.97, 0.88),
    ]);
    final mainPeak = _polygon(size, const [
      Offset(0.03, 0.88),
      Offset(0.38, 0.14),
      Offset(0.73, 0.88),
    ]);
    final snowcap = _polygon(size, const [
      Offset(0.38, 0.14),
      Offset(0.47, 0.34),
      Offset(0.42, 0.31),
      Offset(0.38, 0.37),
      Offset(0.34, 0.31),
      Offset(0.29, 0.34),
    ]);

    canvas
      ..drawPath(rightPeak, companion)
      ..drawPath(mainPeak, main)
      ..drawPath(snowcap, cap)
      ..drawRect(
        Rect.fromLTRB(size.width * 0.03, size.height * 0.92,
            size.width * 0.97, size.height * 0.95),
        cap,
      );
  }

  @override
  bool shouldRepaint(_MountainPainter old) =>
      old.color != color || old.accent != accent;
}
