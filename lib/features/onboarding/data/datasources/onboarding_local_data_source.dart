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

/// Mock local data source backed by an in-memory flag and static page content.
class MockOnboardingLocalDataSource implements OnboardingLocalDataSource {
  /// In-memory flag tracking whether onboarding has been completed.
  bool _isComplete = false;

  /// Static list of onboarding slides returned to callers.
  static const List<OnboardingPageModel> _staticPages = [
    OnboardingPageModel(
      title: 'Order Ready-Mix Concrete',
      subtitle:
          'Get instant pricing and fast delivery for all your construction needs.',
      imagePath: 'assets/images/onboarding1.png',
    ),
    OnboardingPageModel(
      title: 'Real-Time Tracking',
      subtitle:
          'Track your order from plant to site with live delivery updates.',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingPageModel(
      title: 'Manage with Ease',
      subtitle:
          'View invoices, manage your wallet, and handle multiple projects from one place.',
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  Future<List<OnboardingPage>> getOnboardingPages() async {
    return _staticPages;
  }

  @override
  Future<void> setOnboardingComplete() async {
    _isComplete = true;
  }

  @override
  Future<bool> isOnboardingComplete() async {
    return _isComplete;
  }
}
