import 'package:flutter/material.dart';

/// Real Figma-sourced illustration photo, sized/rounded to match
/// [AppIllustrationPlaceholder]'s footprint so it drops straight into the
/// same call sites once the matching artwork is available.
class AppIllustrationImage extends StatelessWidget {
  const AppIllustrationImage({
    super.key,
    required this.asset,
    this.height = 180,
    this.width,
    this.borderRadius = 28,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final double height;
  final double? width;
  final double borderRadius;

  /// `BoxFit.cover` for edge-to-edge hero banners (Figma's `object-cover`);
  /// `BoxFit.contain` for the side-by-side title illustrations and full-
  /// bleed breakout images (Figma's `object-contain`) — pass explicitly to
  /// match the source screen instead of relying on the cover default.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        asset,
        width: width ?? double.infinity,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
      ),
    );
  }
}
