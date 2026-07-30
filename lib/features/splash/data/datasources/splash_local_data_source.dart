import '../../domain/entities/app_launch_state.dart';

/// Contract for the local splash data source.
abstract class SplashLocalDataSource {
  /// Determines the initial app destination by inspecting cached session and
  /// onboarding data. Simulates the splash delay internally.
  Future<AppLaunchState> getAppLaunchState();
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with SharedPreferences / Hive reads when ready.
// ---------------------------------------------------------------------------

/// Simulates a 2000 ms splash delay (logo display + initialisation).
Future<void> _fakeSplashDelay() =>
    Future.delayed(const Duration(milliseconds: 2000));

/// Mock local data source for the splash screen.
///
/// In the mock scenario no user is cached and onboarding has not been shown,
/// so the app always routes to [AppLaunchDestination.getStarted].
class MockSplashLocalDataSource implements SplashLocalDataSource {
  @override
  Future<AppLaunchState> getAppLaunchState() async {
    // Simulate the splash screen display delay.
    await _fakeSplashDelay();

    // Mock decision: no cached user, onboarding not yet shown → getStarted.
    return const AppLaunchState(destination: AppLaunchDestination.getStarted);
  }
}
