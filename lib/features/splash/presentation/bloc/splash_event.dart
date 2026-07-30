import 'package:equatable/equatable.dart';

/// Sealed base class for all splash-related BLoC events.
sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Initialize
// ---------------------------------------------------------------------------

/// Dispatched when the splash screen mounts to begin the initialisation
/// sequence (session check + simulated delay).
final class InitializeSplashEvent extends SplashEvent {
  const InitializeSplashEvent();
}
