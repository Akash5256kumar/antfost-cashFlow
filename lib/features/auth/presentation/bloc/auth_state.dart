import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// Sealed base class for all auth-related BLoC states.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Initial
// ---------------------------------------------------------------------------

/// Default state before any event has been processed.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Emitted while an async auth operation is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

// ---------------------------------------------------------------------------
// Success (authenticated)
// ---------------------------------------------------------------------------

/// Emitted after a successful sign-in, sign-up, or cached-user restoration.
final class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

// ---------------------------------------------------------------------------
// OTP sent
// ---------------------------------------------------------------------------

/// Emitted after the server dispatches an OTP (forgot-passcode / sign-up flow).
final class AuthOtpSent extends AuthState {
  const AuthOtpSent();
}

// ---------------------------------------------------------------------------
// OTP verified
// ---------------------------------------------------------------------------

/// Emitted after the user's OTP has been successfully verified.
final class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

// ---------------------------------------------------------------------------
// Signed out
// ---------------------------------------------------------------------------

/// Emitted once the user has been signed out successfully.
final class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Emitted when any auth operation fails.
final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
