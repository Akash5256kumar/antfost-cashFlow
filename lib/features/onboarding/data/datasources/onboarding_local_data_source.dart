import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/config/app_assets.dart';
import '../../domain/entities/onboarding_page.dart';
import '../models/onboarding_page_model.dart';

/// Contract for the local onboarding data source.
abstract class OnboardingLocalDataSource {
  /// Returns the static list of onboarding slides.
  Future<List<OnboardingPage>> getOnboardingPages();

  /// Persists the onboarding-complete flag.
  Future<void> setOnboardingComplete();

  /// Returns `true` if the user has previously completed onboarding.
  Future<bool> isOnboardingComplete();
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with SharedPreferences when persistence needed.
// ---------------------------------------------------------------------------

/// Real local data source backed by SharedPreferences.
class SharedPrefsOnboardingLocalDataSource implements OnboardingLocalDataSource {
  SharedPrefsOnboardingLocalDataSource(this.prefs);

  final SharedPreferences prefs;
  static const _onboardingCompleteKey = 'ONBOARDING_COMPLETE';

  /// Static list of onboarding slides returned to callers.
  static const List<OnboardingPageModel> _staticPages = [
    OnboardingPageModel(
      title: 'Busy like ants.\nFast like ANTFAST.',
      subtitle:
          'Reliable ready-mix concrete, delivered exactly when you need it.',
      imagePath: AppAssets.figmaTruck,
    ),
    OnboardingPageModel(
      title: 'Location-Based Delivery',
      subtitle:
          'Set the exact project location for accurate planning and '
          'on-time delivery.',
      imagePath: AppAssets.onboardingLocation,
    ),
    OnboardingPageModel(
      title: 'Secure Payments',
      subtitle: 'Pay securely with multiple options and full transparency.',
      imagePath: AppAssets.onboardingPayment,
    ),
  ];

  @override
  Future<List<OnboardingPage>> getOnboardingPages() async {
    return _staticPages;
  }

  @override
  Future<void> setOnboardingComplete() async {
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  @override
  Future<bool> isOnboardingComplete() async {
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
