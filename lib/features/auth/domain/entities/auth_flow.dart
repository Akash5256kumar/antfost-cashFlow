import 'package:equatable/equatable.dart';

import 'user.dart';

enum AuthNextStep { kyc, home, verifyOtp }

class OtpChallenge extends Equatable {
  const OtpChallenge({
    required this.verificationId,
    required this.contact,
    required this.maskedContact,
    required this.expiresAt,
    this.resendAvailableAt,
  });

  final String verificationId;
  final String contact;
  final String maskedContact;
  final DateTime expiresAt;
  final DateTime? resendAvailableAt;

  @override
  List<Object?> get props => [
    verificationId,
    contact,
    maskedContact,
    expiresAt,
    resendAvailableAt,
  ];
}

class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.nextStep,
  });

  final User user;
  final String accessToken;
  final String refreshToken;
  final AuthNextStep? nextStep;

  @override
  List<Object?> get props => [user, accessToken, refreshToken, nextStep];
}

class PasswordResetVerification extends Equatable {
  const PasswordResetVerification({required this.resetToken});

  final String resetToken;

  @override
  List<Object?> get props => [resetToken];
}
