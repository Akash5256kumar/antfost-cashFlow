import 'package:equatable/equatable.dart';

/// Represents the screen the app should navigate to after the splash delay.
enum AppLaunchDestination {
  /// User has never opened the app — show the onboarding flow.
  onboarding,

  /// Onboarding is done but user is not authenticated — show Get Started.
  getStarted,

  /// User is authenticated and KYC is verified — go directly to Home.
  home,

  /// User is authenticated but KYC is not yet verified — prompt for KYC.
  kycVerification,
}

/// Domain entity that encapsulates the launch routing decision made during
/// the splash screen initialisation phase.
class AppLaunchState extends Equatable {
  /// Where the app should navigate after the splash screen completes.
  final AppLaunchDestination destination;

  /// Whether Home should present the business-verification-in-review state.
  final bool verificationUnderReview;

  const AppLaunchState({
    required this.destination,
    this.verificationUnderReview = false,
  });

  @override
  List<Object?> get props => [destination, verificationUnderReview];
}
