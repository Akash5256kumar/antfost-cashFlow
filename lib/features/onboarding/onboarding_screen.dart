import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_breakpoints.dart';
import '../../app/config/app_durations.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_page_indicator.dart';
import 'onboarding_constants.dart';
import 'presentation/bloc/onboarding_bloc.dart';
import 'presentation/bloc/onboarding_event.dart';
import 'presentation/bloc/onboarding_state.dart';

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
    // Load onboarding data through the BLoC on screen init.
    context.read<OnboardingBloc>().add(const LoadOnboardingEvent());
  }

  /// Dispatches [NextPageEvent] when not on the last page, or
  /// [CompleteOnboardingEvent] when on the last page.
  void _nextPage(int currentIndex) {
    if (currentIndex < OnboardingConstants.pages.length - 1) {
      context.read<OnboardingBloc>().add(const NextPageEvent());
    } else {
      context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          // Navigate to the Get Started screen once onboarding is completed.
          Navigator.of(context).pushReplacementNamed(AppRoutes.getStarted);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              // Derive the current page index from the BLoC state.
              // Fall back to 0 while the bloc is still initialising / loading.
              final currentIndex =
                  state is OnboardingLoaded ? state.currentIndex : 0;

              // Keep the PageController in sync with the BLoC index so that
              // programmatic page changes (e.g. from NextPageEvent) animate
              // the underlying PageView correctly.
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet =
                      constraints.maxWidth > AppBreakpoints.tablet;

                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: OnboardingConstants.pages.length,
                          // When the user swipes manually, keep the BLoC in
                          // sync by dispatching the appropriate page event.
                          onPageChanged: (index) {
                            context
                                .read<OnboardingBloc>()
                                .add(GoToPageEvent(index));
                          },
                          itemBuilder: (context, index) => _OnboardingPage(
                            data: OnboardingConstants.pages[index],
                            isTablet: isTablet,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: AppPageIndicator(
                          itemCount: OnboardingConstants.pages.length,
                          currentIndex: currentIndex,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          bottomInset > 0
                              ? AppSpacing.sm
                              : AppSpacing.md,
                        ),
                        child: AppGradientButton(
                          onPressed: () => _nextPage(currentIndex),
                          label: currentIndex <
                                  OnboardingConstants.pages.length - 1
                              ? OnboardingConstants.continueLabel
                              : OnboardingConstants.getStartedLabel,
                        ),
                      ),
                    ],
                  );
                },
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
  final bool isTablet;

  const _OnboardingPage({required this.data, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final illustration = data.illustration;

        // Page 1 (truck) has no background; pages 2 & 3 show the blob.
        final isWide = illustration.type == OnboardingIllustrationType.asset;

        // ── Background blob size (pages 2 & 3 only) ───────────────────────
        final bgDiameter = width * 0.80;

        // ── Icon area ─────────────────────────────────────────────────────
        // • Page 1 (truck): sized directly — no blob to constrain it.
        // • Pages 2 & 3: inset from the blob with a constant 24 px gap so
        //   the breathing-room between icon and blob edge is identical.
        const double iconPad = 24.0;
        final maxIconW = isWide ? width * 0.88 : bgDiameter - iconPad * 2;
        final maxIconH = isWide ? width * 0.52 : bgDiameter - iconPad * 2;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Centre the whole image+text block vertically so the image sits
            // in the upper-middle of the page and the text follows directly.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Image + background (Stack sizes to its content) ───────────
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Background blob — hidden on page 1 (truck)
                  if (!isWide)
                    CustomPaint(
                      size: Size(bgDiameter, bgDiameter),
                      painter: const _IllustrationBgPainter(),
                    ),

                  // Illustration centred over the blob
                  _OnboardingIllustration(
                    illustration: illustration,
                    maxWidth: maxIconW,
                    maxHeight: maxIconH,
                  ),
                ],
              ),

              // ── Gap: image → title ────────────────────────────────────────
              const SizedBox(height: 50),

              // ── Title ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onboardingTitle,
                ),
              ),

              // ── Gap: title → description ──────────────────────────────────
              const SizedBox(height: 10),

              // ── Description ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl,
                ),
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onboardingSubtitle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  final OnboardingIllustrationSpec illustration;
  final double maxWidth;
  final double maxHeight;

  const _OnboardingIllustration({
    required this.illustration,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    switch (illustration.type) {
      case OnboardingIllustrationType.asset:
        return Image.asset(
          illustration.assetPath,
          width: maxWidth,
          height: maxHeight,
          fit: BoxFit.contain,
        );
      case OnboardingIllustrationType.svg:
        return SvgPicture.asset(
          illustration.assetPath,
          width: maxWidth,
          height: maxHeight,
          fit: BoxFit.contain,
        );
      case OnboardingIllustrationType.svgEmbeddedPng:
        return _SvgEmbeddedPngImage(
          assetPath: illustration.assetPath,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
    }
  }
}

// Loads an SVG file that embeds a raster PNG, extracts the base64 payload,
// and renders it as a normal image.
class _SvgEmbeddedPngImage extends StatefulWidget {
  final String assetPath;
  final double maxWidth;
  final double maxHeight;

  const _SvgEmbeddedPngImage({
    required this.assetPath,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  State<_SvgEmbeddedPngImage> createState() => _SvgEmbeddedPngImageState();
}

class _SvgEmbeddedPngImageState extends State<_SvgEmbeddedPngImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _extract();
  }

  Future<void> _extract() async {
    final svg = await rootBundle.loadString(widget.assetPath);
    final match = RegExp(
      r'(?:xlink:href|href)="data:image/(?:png|jpeg|jpg);base64,([^"]+)"',
    ).firstMatch(svg);
    if (match != null && mounted) {
      final decoded = base64Decode(
        match.group(1)!.replaceAll(RegExp(r'\s'), ''),
      );
      setState(() => _bytes = decoded);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes == null) {
      return SizedBox(width: widget.maxWidth, height: widget.maxHeight);
    }
    return Image.memory(
      _bytes!,
      width: widget.maxWidth,
      height: widget.maxHeight,
      fit: BoxFit.contain,
    );
  }
}

// ── Illustration background painter ──────────────────────────────────────────
//
// Draws a layered modern background behind every onboarding illustration:
//   1. Blurred outer halo  (depth / glow)
//   2. Solid blob shape    (main surface)
//   3. White radial highlight (light source feel)
//   4. Two subtle border rings
//   5. Three floating accent dots
//
// Works for both circles (pages 2 & 3) and wide ellipses (page 1 truck).
class _IllustrationBgPainter extends CustomPainter {
  const _IllustrationBgPainter();

  static const Color _blob = Color(0xFFECEAFF);
  static const Color _accent = Color(0xFF7A6BFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final r = size.shortestSide / 2; // reference radius for dot placement
    final ovalRect = Rect.fromCenter(
      center: center,
      width: size.width,
      height: size.height,
    );

    // 1 ── Blurred outer halo
    canvas.drawOval(
      ovalRect.inflate(size.shortestSide * 0.10),
      Paint()
        ..color = _blob.withValues(alpha: 0.40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    // 2 ── Main solid blob
    canvas.drawOval(ovalRect, Paint()..color = _blob);

    // 3 ── White radial highlight (top-centre light source)
    final highlightRect = Rect.fromCenter(
      center: Offset(cx, cy - size.height * 0.10),
      width: size.width * 0.70,
      height: size.height * 0.60,
    );
    canvas.drawOval(
      ovalRect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.30),
          radius: 0.75,
          colors: [
            Colors.white.withValues(alpha: 0.52),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(highlightRect),
    );

    // 4a ── Inner border ring
    canvas.drawOval(
      ovalRect.deflate(size.shortestSide * 0.035),
      Paint()
        ..color = _accent.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );

    // 4b ── Outer border ring
    canvas.drawOval(
      ovalRect.inflate(size.shortestSide * 0.065),
      Paint()
        ..color = _accent.withValues(alpha: 0.07)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 5 ── Floating accent dots (outside the main blob)
    _dot(canvas, Offset(cx + r * 1.02, cy - r * 0.58), r * 0.072, 0.22);
    _dot(canvas, Offset(cx - r * 0.95, cy - r * 0.52), r * 0.052, 0.16);
    _dot(canvas, Offset(cx + r * 0.38, cy + r * 1.05), r * 0.058, 0.19);
  }

  void _dot(Canvas canvas, Offset c, double radius, double opacity) {
    canvas.drawCircle(
      c,
      radius,
      Paint()..color = _accent.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
