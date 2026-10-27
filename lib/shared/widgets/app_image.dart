import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'mountain_logo.dart';

/// Network image with a loading tint and a branded fallback. An empty [url]
/// or a failed request both show the fallback, so layouts never break.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 10,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String url;
  final double aspectRatio;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? const _ImageFallback()
        : Image.network(
            url,
            fit: fit,
            semanticLabel: semanticLabel,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const ColoredBox(color: AppColors.forestSoft),
            errorBuilder: (context, error, stackTrace) =>
                const _ImageFallback(),
          );
    return AspectRatio(aspectRatio: aspectRatio, child: image);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.forestSoft,
      child: Center(
        child: MountainLogo(size: 64, color: Color(0xFF9DB8B3)),
      ),
    );
  }
}