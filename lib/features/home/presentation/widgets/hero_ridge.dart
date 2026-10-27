import 'package:flutter/material.dart';

/// Decorative mountain ridgeline used behind the hero when no photo is set.
class HeroRidge extends StatelessWidget {
  const HeroRidge({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: CustomPaint(painter: _RidgePainter()),
    );
  }
}

class _RidgePainter extends CustomPainter {
  const _RidgePainter();

  static const List<Offset> _back = [
    Offset(0, 0.74),
    Offset(0.10, 0.58),
    Offset(0.18, 0.66),
    Offset(0.30, 0.46),
    Offset(0.42, 0.64),
    Offset(0.55, 0.52),
    Offset(0.68, 0.68),
    Offset(0.80, 0.54),
    Offset(0.92, 0.66),
    Offset(1, 0.60),
  ];

  static const List<Offset> _middle = [
    Offset(0, 0.84),
    Offset(0.12, 0.70),
    Offset(0.24, 0.80),
    Offset(0.38, 0.64),
    Offset(0.50, 0.78),
    Offset(0.64, 0.66),
    Offset(0.78, 0.80),
    Offset(0.90, 0.70),
    Offset(1, 0.78),
  ];

  static const List<Offset> _front = [
    Offset(0, 0.92),
    Offset(0.15, 0.82),
    Offset(0.30, 0.90),
    Offset(0.48, 0.80),
    Offset(0.66, 0.90),
    Offset(0.82, 0.82),
    Offset(1, 0.90),
  ];

  void _fill(Canvas canvas, Size size, List<Offset> ridge, Color color) {
    final path = Path()..moveTo(0, size.height);
    for (final point in ridge) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.2),
      36,
      Paint()..color = const Color(0x2ED7A86E),
    );
    _fill(canvas, size, _back, const Color(0xFF12483F));
    _fill(canvas, size, _middle, const Color(0xFF0F423A));
    _fill(canvas, size, _front, const Color(0xFF0D3D37));
  }

  @override
  bool shouldRepaint(_RidgePainter oldDelegate) => false;
}