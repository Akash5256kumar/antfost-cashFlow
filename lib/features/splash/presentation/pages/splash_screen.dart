import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/config/app_assets.dart';
import '../../../../app/config/app_breakpoints.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/decorative_rings.dart';
import '../../domain/entities/app_launch_state.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';
import '../../splash_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashReady) {
          final route = switch (state.destination) {
            AppLaunchDestination.onboarding => AppRoutes.onboarding,
            AppLaunchDestination.getStarted => AppRoutes.getStarted,
            AppLaunchDestination.home => AppRoutes.home,
            AppLaunchDestination.kycVerification => AppRoutes.kycVerification,
          };
          Navigator.of(context).pushReplacementNamed(route);
        }
        if (state is SplashError) {
          // On error still navigate to getStarted as safe fallback
          Navigator.of(context).pushReplacementNamed(AppRoutes.getStarted);
        }
      },
      builder: (context, state) {
        if (state is SplashInitial) {
          context.read<SplashBloc>().add(const InitializeSplashEvent());
        }
        return const _SplashView();
      },
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

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
