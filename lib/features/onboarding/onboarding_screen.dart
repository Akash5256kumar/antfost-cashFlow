import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/config/app_durations.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_page_indicator.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';
import 'onboarding_constants.dart';
import 'presentation/bloc/onboarding_bloc.dart';
import 'presentation/bloc/onboarding_event.dart';
import 'presentation/bloc/onboarding_state.dart';

/// Ported from the new Figma design's `components/Onboarding.tsx` — a
/// Skip button, centered logo, full-bleed illustration, title/subtitle,
/// pill-dot pagination, and a single Continue CTA that becomes "Get
/// Started" on the last slide and hands off straight to Login.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(const LoadOnboardingEvent());
  }

  void _nextPage(int currentIndex) {
    if (currentIndex < OnboardingConstants.pages.length - 1) {
      context.read<OnboardingBloc>().add(const NextPageEvent());
    } else {
      context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
    }
  }

  void _skip() {
    context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          // The new flow drops the separate "Get Started" chooser screen —
          // onboarding hands off straight to Login.
          Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              final currentIndex = state is OnboardingLoaded
                  ? state.currentIndex
                  : 0;
              final isLast =
                  currentIndex == OnboardingConstants.pages.length - 1;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_pageController.hasClients &&
                    _pageController.page?.round() != currentIndex) {
                  _pageController.animateToPage(
                    currentIndex,
                    duration: AppDurations.pageScroll,
                    curve: Curves.easeInOut,
                  );
                }
              });

              return Padding(
                // Figma: `px-8 pb-6` — 32px sides, 24px bottom.
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxxl(context),
                  0,
                  AppSpacing.xxxl(context),
                  context.scaledV(24),
                ),
                child: Column(
                  children: [
                    // ── Skip ──────────────────────────────────────────────
                    SizedBox(
                      height: context.scaledV(28),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: isLast
                            ? null
                            : TextButton(
                                onPressed: _skip,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: context.scaled(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // ── Logo ──────────────────────────────────────────────
                    SizedBox(height: context.scaledV(14)),
                    SvgPicture.asset(
                      AppAssets.antfostLogo,
                      width: context.scaled(245),
                    ),

                    // ── Illustration + title + subtitle (swipeable) ───────
                    SizedBox(height: context.scaledV(18)),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: OnboardingConstants.pages.length,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                            GoToPageEvent(index),
                          );
                        },
                        itemBuilder: (context, index) => _OnboardingPage(
                          data: OnboardingConstants.pages[index],
                        ),
                      ),
                    ),

                    // ── Pagination ────────────────────────────────────────
                    SizedBox(height: context.scaledV(18)),
                    AppPageIndicator(
                      itemCount: OnboardingConstants.pages.length,
                      currentIndex: currentIndex,
                    ),

                    // ── Continue ──────────────────────────────────────────
                    SizedBox(height: context.scaledV(28)),
                    PrimaryButton(
                      onPressed: () => _nextPage(currentIndex),
                      label: isLast
                          ? OnboardingConstants.getStartedLabel
                          : OnboardingConstants.continueLabel,
                      // Figma onboarding-only override: `h-[54px] rounded-2xl`.
                      height: context.scaled(54),
                      radius: context.scaled(16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageContent data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Figma: the illustration is `-mx-8` (breaks out of the screen's
        // 32px side padding to run edge-to-edge) at a fixed 375px height,
        // `object-contain`. Every slide uses this same full-bleed
        // treatment now that all three have real photo illustrations.
        final hPad = AppSpacing.xxxl(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // `Flexible` (not a fixed height) so this shrinks below the
            // Figma-spec 375px on shorter devices instead of overflowing —
            // the title/subtitle/gaps below it always get their natural
            // size first.
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: context.scaledV(375)),
                child: OverflowBox(
                  maxWidth: constraints.maxWidth + hPad * 2,
                  minWidth: 0,
                  child: SizedBox(
                    width: constraints.maxWidth + hPad * 2,
                    child: _OnboardingIllustration(illustration: data.illustration),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.scaledV(16)),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.onboardingTitle(context),
            ),
            SizedBox(height: context.scaledV(9)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.scaled(290)),
              child: Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.onboardingSubtitle(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  final OnboardingIllustrationSpec illustration;

  const _OnboardingIllustration({required this.illustration});

  @override
  Widget build(BuildContext context) {
    switch (illustration.type) {
      case OnboardingIllustrationType.asset:
        return Image.asset(illustration.assetPath, fit: BoxFit.contain);
      case OnboardingIllustrationType.svg:
        return SvgPicture.asset(illustration.assetPath, fit: BoxFit.contain);
      case OnboardingIllustrationType.raster:
        // `cover` — the real photos fill the full-bleed box with no
        // letterbox gap, matching how the Figma renders actually look.
        return SvgEmbeddedRasterImage(
          assetPath: illustration.assetPath,
          fit: BoxFit.cover,
        );
    }
  }
}
