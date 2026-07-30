import 'package:equatable/equatable.dart';

/// Sealed base class for all auth-related BLoC events.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Sign in
// ---------------------------------------------------------------------------

/// Dispatched when the user submits the sign-in form.
final class SignInEvent extends AuthEvent {
  /// Email address or phone number, depending on [isEmail].
  final String contact;
  final String passcode;

  /// `true` when [contact] is an email, `false` when it is a phone number.
  final bool isEmail;

  const SignInEvent({
    required this.contact,
    required this.passcode,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, passcode, isEmail];
}

// ---------------------------------------------------------------------------
// Sign up
// ---------------------------------------------------------------------------

/// Dispatched when the user submits the registration form.
final class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String passcode;

  const SignUpEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.passcode,
  });

  @override
  List<Object?> get props => [name, email, phone, company, passcode];
}

// ---------------------------------------------------------------------------
// Verify OTP
// ---------------------------------------------------------------------------

/// Dispatched when the user submits the OTP entry screen.
final class VerifyOtpEvent extends AuthEvent {
  final String contact;
  final String otp;
  final bool isEmail;

  const VerifyOtpEvent({
    required this.contact,
    required this.otp,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, otp, isEmail];
}

// ---------------------------------------------------------------------------
// Forgot passcode
// ---------------------------------------------------------------------------

/// Dispatched when the user requests a passcode reset OTP.
final class ForgotPasscodeEvent extends AuthEvent {
  final String contact;
  final bool isEmail;

  const ForgotPasscodeEvent({
    required this.contact,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, isEmail];
}

// ---------------------------------------------------------------------------
// Reset passcode
// ---------------------------------------------------------------------------

/// Dispatched when the user submits the new passcode after OTP verification.
final class ResetPasscodeEvent extends AuthEvent {
  final String contact;
  final String otp;
  final String newPasscode;

  const ResetPasscodeEvent({
    required this.contact,
    required this.otp,
    required this.newPasscode,
  });

  @override
  List<Object?> get props => [contact, otp, newPasscode];
}

// ---------------------------------------------------------------------------
// Sign out
// ---------------------------------------------------------------------------

/// Dispatched when the user taps the sign-out button.
final class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

// ---------------------------------------------------------------------------
// Check cached user
// ---------------------------------------------------------------------------

/// Dispatched on app start to restore a previously authenticated session.
final class CheckCachedUserEvent extends AuthEvent {
  const CheckCachedUserEvent();
}
