import 'package:flutter/material.dart';

/// Renders a native Figma PNG/JPEG export with Flutter's image codec.
///
/// The name is retained temporarily to avoid churn across existing screens.
class SvgEmbeddedRasterImage extends StatelessWidget {
  const SvgEmbeddedRasterImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  });

  final String assetPath;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      errorBuilder: (context, error, stackTrace) =>
          SizedBox(width: width, height: height),
    );
  }
}
