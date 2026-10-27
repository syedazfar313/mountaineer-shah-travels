import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Tappable card surface: lifts slightly on hover or keyboard focus and
/// shows a visible focus ring. Motion is skipped when the user prefers it.
class HoverSurface extends StatefulWidget {
  const HoverSurface({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final lifted = _hovered || _focused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return AnimatedContainer(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _focused ? AppColors.forest : AppColors.border,
          width: _focused ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: lifted ? const Color(0x240B3B35) : const Color(0x0F000000),
            blurRadius: lifted ? 24 : 8,
            offset: Offset(0, lifted ? 12 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          child: widget.child,
        ),
      ),
    );
  }
}