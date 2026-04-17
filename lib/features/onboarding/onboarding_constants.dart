import '../../app/config/app_assets.dart';

enum OnboardingIllustrationType { asset, svg, svgEmbeddedPng }

class OnboardingIllustrationSpec {
  final String assetPath;
  final OnboardingIllustrationType type;
  final double mobileWidthFactor;
  final double tabletWidthFactor;
  final double mobileMinWidth;
  final double mobileMaxWidth;
  final double tabletMinWidth;
  final double tabletMaxWidth;
  final double bottomFactor;

  const OnboardingIllustrationSpec({
    required this.assetPath,
    required this.type,
    required this.mobileWidthFactor,
    required this.tabletWidthFactor,
    required this.mobileMinWidth,
    required this.mobileMaxWidth,
    required this.tabletMinWidth,
    required this.tabletMaxWidth,
    required this.bottomFactor,
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

abstract final class OnboardingConstants {
  static const String continueLabel = 'Continue';
  static const String getStartedLabel = 'Get Started';

  static const double visualHeightTabletFactor = 0.50;
  static const double visualHeightMobileFactor = 0.54;
  static const double blobWidthTabletFactor = 0.68;
  static const double blobWidthMobileFactor = 0.96;
  static const double blobWidthMin = 320;
  static const double blobWidthTabletMax = 544;
  static const double blobWidthMobileMax = 396;
  static const double blobHeightFactor = 260 / 362;
  static const double ringSizeTabletFactor = 0.16;
  static const double ringSizeMobileFactor = 0.25;
  static const double ringTopFactor = 0.08;
  static const double ringLeftFactor = 0.11;
  static const double blobLeftFactor = 0.04;
  static const double blobTopFactor = 0.41;
  static const OnboardingIllustrationSpec truckIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.mixtureMachine,
        type: OnboardingIllustrationType.asset,
        mobileWidthFactor: 0.81,
        tabletWidthFactor: 0.58,
        mobileMinWidth: 292,
        mobileMaxWidth: 332,
        tabletMinWidth: 292,
        tabletMaxWidth: 420,
        bottomFactor: 0.03,
      );

  static const OnboardingIllustrationSpec locationIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.propertyLogo,
        type: OnboardingIllustrationType.svgEmbeddedPng,
        mobileWidthFactor: 0.86,
        tabletWidthFactor: 0.62,
        mobileMinWidth: 300,
        mobileMaxWidth: 344,
        tabletMinWidth: 340,
        tabletMaxWidth: 470,
        bottomFactor: 0.04,
      );

  static const OnboardingIllustrationSpec paymentIllustration =
      OnboardingIllustrationSpec(
        assetPath: AppAssets.cardPaymentIcon,
        type: OnboardingIllustrationType.svgEmbeddedPng,
        mobileWidthFactor: 0.62,
        tabletWidthFactor: 0.46,
        mobileMinWidth: 220,
        mobileMaxWidth: 258,
        tabletMinWidth: 250,
        tabletMaxWidth: 340,
        bottomFactor: 0.02,
      );

  static const List<OnboardingPageContent> pages = [
    OnboardingPageContent(
      title: 'Busy like ants. Fast like\nANTFAST.',
      subtitle:
          'Like ants working together, we move\nfast, stay organized, and deliver\nexactly what you need-every time.',
      illustration: truckIllustration,
    ),
    OnboardingPageContent(
      title: 'Location-Based Delivery',
      subtitle:
          'With ANTFAST, you get faster delivery,\nbetter prices, and guaranteed quality-all\nin the palm of your hand.',
      illustration: locationIllustration,
    ),
    OnboardingPageContent(
      title: 'Secure Payments',
      subtitle:
          'Pay securely with card or payment link.\nYour payment is protected until order\ncompletion.',
      illustration: paymentIllustration,
    ),
  ];
}
