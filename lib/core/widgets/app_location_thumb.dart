import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import 'svg_embedded_raster_image.dart';

/// Project/order/location thumbnail — shows a real matching site photo
/// (ported from the new Figma design's referenced Unsplash photos) when
/// [location] matches a known site, falling back to an icon tile otherwise.
class AppLocationThumb extends StatelessWidget {
  const AppLocationThumb({
    super.key,
    required this.location,
    this.size = 48,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.icon = Icons.local_shipping_outlined,
    this.imageUrl,
  });

  final String location;
  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData icon;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final photo = AppAssets.photoForLocation(location);
    final w = width ?? size;
    final h = height ?? size;
    final remoteImage = imageUrl?.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: remoteImage != null && remoteImage.startsWith('http')
          ? Image.network(
              remoteImage,
              width: w,
              height: h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(photo, w, h),
            )
          : _fallback(photo, w, h),
    );
  }

  Widget _fallback(String? photo, double w, double h) => photo != null
      ? SvgEmbeddedRasterImage(
          assetPath: photo,
          width: w,
          height: h,
          fit: BoxFit.cover,
        )
      : Container(
          width: w,
          height: h,
          color: AppColors.muted,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: (w < h ? w : h) * 0.46,
            color: AppColors.primary,
          ),
        );
}
