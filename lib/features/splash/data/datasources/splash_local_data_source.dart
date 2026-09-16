import 'package:dio/dio.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/services/api_client.dart';
import '../../domain/entities/app_launch_state.dart';
import '../../../../core/services/secure_storage_service.dart';

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

    // Mock decision: no cached user, onboarding not yet shown → onboarding.
    return const AppLaunchState(destination: AppLaunchDestination.onboarding);
  }
}

/// Uses the secure access-token store as the single source of truth for a
/// restored session. No network call is needed before rendering the app.
class SecureSplashLocalDataSource implements SplashLocalDataSource {
  SecureSplashLocalDataSource(
    this._storage,
    this._networkInfo,
    this._apiClient,
  );
  final SecureStorageService _storage;
  final NetworkInfo _networkInfo;
  final ApiClient _apiClient;

  @override
  Future<AppLaunchState> getAppLaunchState() async {
    await _fakeSplashDelay();
    final accessToken = await _storage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      // Only a 401 makes this a signed-out session. On a temporary outage we
      // preserve the session and let the feature screen show its retry state.
      if (await _networkInfo.isConnected) {
        try {
          final response = await _apiClient.get<Map<String, dynamic>>('/me');
          final data = response.data;
          final access = data?['access'];
          final user = data?['user'];
          final nextStep = access is Map
              ? access['nextStep']?.toString().toLowerCase()
              : data?['nextStep']?.toString().toLowerCase();
          final kyc = (data?['kyc'] ?? (user is Map ? user['kycStatus'] : null))
              ?.toString()
              .toLowerCase();
          if (nextStep == 'kyc' || kyc == 'not_submitted') {
            // A fully submitted business KYC is allowed into Home while the
            // team reviews it. Only incomplete KYC must start again at login.
            final kycResponse = await _apiClient.get<Map<String, dynamic>>(
              '/kyc/status',
            );
            final status = kycResponse.data?['status']
                ?.toString()
                .toLowerCase();
            if (status == 'pending' || status == 'under_review') {
              return const AppLaunchState(
                destination: AppLaunchDestination.home,
                verificationUnderReview: true,
              );
            }
            await _storage.clearTokens();
            _apiClient.clearAccessToken();
            return const AppLaunchState(
              destination: AppLaunchDestination.getStarted,
            );
          }
          if (kyc == 'pending' || kyc == 'under_review') {
            return const AppLaunchState(
              destination: AppLaunchDestination.home,
              verificationUnderReview: true,
            );
          }
        } on DioException catch (error) {
          if (error.response?.statusCode == 401) {
            return const AppLaunchState(
              destination: AppLaunchDestination.getStarted,
            );
          }
        }
      }
      return const AppLaunchState(destination: AppLaunchDestination.home);
    }
    return const AppLaunchState(destination: AppLaunchDestination.onboarding);
  }
}
