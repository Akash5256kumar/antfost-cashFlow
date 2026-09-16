import 'package:equatable/equatable.dart';

import '../../domain/entities/app_launch_state.dart';

/// Sealed base class for all splash-related BLoC states.
sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Initial
// ---------------------------------------------------------------------------

/// Default state before the splash initialisation begins.
final class SplashInitial extends SplashState {
  const SplashInitial();
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Emitted while the splash delay and session checks are in progress.
final class SplashLoading extends SplashState {
  const SplashLoading();
}

// ---------------------------------------------------------------------------
// Ready
// ---------------------------------------------------------------------------

/// Emitted once the initialisation is complete and the app knows where
/// to navigate next.
final class SplashReady extends SplashState {
  /// The screen the app should navigate to after the splash.
  final AppLaunchDestination destination;
  final bool verificationUnderReview;

  const SplashReady(this.destination, {this.verificationUnderReview = false});

  @override
  List<Object?> get props => [destination, verificationUnderReview];
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Emitted when the splash initialisation fails unexpectedly.
final class SplashError extends SplashState {
  /// Human-readable error message to display to the user.
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
