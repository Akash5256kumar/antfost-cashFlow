import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/di/injection.dart';
import '../services/app_assets_api_service.dart';

class AppRemoteImage extends StatelessWidget {
  /// The key to look up in the remote registry (e.g. 'homeHeader' for screens, 'card' for paymentMethods).
  /// For sets, pass the URL directly or a structured way if needed.
  final String? remoteUrl;
  
  /// The local fallback asset path.
  final String fallbackAssetPath;
  
  final BoxFit fit;
  final double? width;
  final double? height;
  final FilterQuality filterQuality;
  final Alignment alignment;

  const AppRemoteImage({
    super.key,
    required this.remoteUrl,
    required this.fallbackAssetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.filterQuality = FilterQuality.high,
    this.alignment = Alignment.center,
  });

  /// Factory for screen images
  factory AppRemoteImage.screen({
    Key? key,
    required String screenKey,
    required String fallback,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    final registry = sl<AppAssetsRegistry>();
    return AppRemoteImage(
      key: key,
      remoteUrl: registry.getScreenImageUrl(screenKey),
      fallbackAssetPath: fallback,
      fit: fit,
      width: width,
      height: height,
    );
  }

  bool _isSvg(String path) => path.toLowerCase().endsWith('.svg');

  Widget _buildFallback() {
    if (_isSvg(fallbackAssetPath)) {
      return SvgPicture.asset(
        fallbackAssetPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }
    return Image.asset(
      fallbackAssetPath,
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      isAntiAlias: true,
      alignment: alignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (remoteUrl == null || remoteUrl!.isEmpty) {
      return _buildFallback();
    }

    if (_isSvg(remoteUrl!)) {
      return SvgPicture.network(
        remoteUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: (context) => _buildFallback(),
      );
    }

    return CachedNetworkImage(
      imageUrl: remoteUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
      errorWidget: (context, url, error) => _buildFallback(),
      placeholder: (context, url) => _buildFallback(),
    );
  }
}
