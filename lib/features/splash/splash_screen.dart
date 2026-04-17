import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/config/app_breakpoints.dart';
import '../../app/config/app_durations.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/decorative_rings.dart';
import 'splash_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppDurations.splashDelay, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mediaQuery = MediaQuery.of(context);
            final size = mediaQuery.size;
            final isTablet = constraints.maxWidth > AppBreakpoints.tablet;
            final blobSize =
                constraints.maxWidth *
                (isTablet
                    ? SplashConstants.blobSizeTabletFactor
                    : SplashConstants.blobSizeMobileFactor);
            final ringSize =
                constraints.maxWidth *
                (isTablet
                    ? SplashConstants.ringSizeTabletFactor
                    : SplashConstants.ringSizeMobileFactor);
            final logoWidth =
                constraints.maxWidth *
                (isTablet
                    ? SplashConstants.logoWidthTabletFactor
                    : SplashConstants.logoWidthMobileFactor);

            return Stack(
              children: [
                Positioned(
                  top: blobSize * SplashConstants.blobTopFactor,
                  right: blobSize * SplashConstants.blobSideFactor,
                  child: Container(
                    width: blobSize,
                    height: blobSize,
                    decoration: const BoxDecoration(
                      color: AppColors.splashBlob,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: blobSize * SplashConstants.blobTopFactor,
                  left: blobSize * SplashConstants.blobSideFactor,
                  child: Container(
                    width: blobSize,
                    height: blobSize,
                    decoration: const BoxDecoration(
                      color: AppColors.splashBlob,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * SplashConstants.ringVerticalFactor,
                  left:
                      constraints.maxWidth *
                      SplashConstants.ringHorizontalFactor,
                  child: DecorativeRings(
                    color: AppColors.ringSplash,
                    size: ringSize,
                  ),
                ),
                Positioned(
                  bottom:
                      mediaQuery.padding.bottom +
                      size.height * SplashConstants.ringVerticalFactor,
                  right:
                      constraints.maxWidth *
                      SplashConstants.ringHorizontalFactor,
                  child: DecorativeRings(
                    color: AppColors.ringSplash,
                    size: ringSize,
                  ),
                ),
                Center(
                  child: RepaintBoundary(
                    child: SvgPicture.asset(
                      AppAssets.antfostLogo,
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
