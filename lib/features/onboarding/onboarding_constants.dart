import '../../app/config/app_assets.dart';

enum OnboardingIllustrationType { asset, svg, raster }

class OnboardingIllustrationSpec {
  final String assetPath;
  final OnboardingIllustrationType type;

  /// Whether this illustration is a full-bleed photo (no padding/tinted
  /// backdrop) rather than a small icon shown on a tinted card.
  final bool fullBleed;

  const OnboardingIllustrationSpec({
    required this.assetPath,
    required this.type,
    this.fullBleed = false,
  });
}

class OnboardingPageContent {
  final String title;
  final String subtitle;
  final OnboardingIllustrationSpec illustration;

  const OnboardingPageContent({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}

/// Content ported verbatim from the new Figma design's
/// `components/Onboarding.tsx` (3 slides, copy matches exactly).
///
/// All three illustrations are the genuine `src/imports/*.jpg` source
/// files from the Figma Make project (3.jpg / 4.jpg / 1.jpg) at their
/// original resolution — not MCP-recoverable, so pulled directly from the
/// project's own copy of the Make file's asset folder.
abstract final class OnboardingConstants {
  static const String continueLabel = 'Continue';
  static const String getStartedLabel = 'Get Started';

  static const OnboardingIllustrationSpec truckIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.figmaTruck,
        type: OnboardingIllustrationType.raster,
        fullBleed: true,
      );

  static const OnboardingIllustrationSpec locationIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.onboardingLocation,
        type: OnboardingIllustrationType.raster,
        fullBleed: true,
      );

  static const OnboardingIllustrationSpec paymentIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.onboardingPayment,
        type: OnboardingIllustrationType.raster,
        fullBleed: true,
      );

  static const List<OnboardingPageContent> pages = [
    OnboardingPageContent(
      title: 'Busy like ants.\nFast like ANTFAST.',
      subtitle:
          'Reliable ready-mix concrete, delivered exactly when you need it.',
      illustration: truckIllustration,
    ),
    OnboardingPageContent(
      title: 'Location-Based Delivery',
      subtitle:
          'Set the exact project location for accurate planning and '
          'on-time delivery.',
      illustration: locationIllustration,
    ),
    OnboardingPageContent(
      title: 'Secure Payments',
      subtitle: 'Pay securely with multiple options and full transparency.',
      illustration: paymentIllustration,
    ),
  ];
}
