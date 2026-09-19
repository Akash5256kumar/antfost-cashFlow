import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.usernameOrMobile,
    this.countryCode,
  });
  final String usernameOrMobile;
  final String? countryCode;
  @override
  List<Object?> get props => [usernameOrMobile, countryCode];
}

final class VerifySignInOtpEvent extends AuthEvent {
  const VerifySignInOtpEvent({
    required this.verificationId,
    required this.otp,
  });
  final String verificationId;
  final String otp;
  @override
  List<Object?> get props => [verificationId, otp];
}

final class SignUpBusinessEvent extends AuthEvent {
  const SignUpBusinessEvent({
    required this.companyName,
    this.username,
    required this.registeredMobile,
    required this.countryCode,
    required this.email,
  });
  final String companyName;
  final String? username;
  final String registeredMobile, countryCode, email;
  @override
  List<Object?> get props => [
    companyName,
    username,
    registeredMobile,
    countryCode,
    email,
  ];
}

final class SignUpIndividualEvent extends AuthEvent {
  const SignUpIndividualEvent({
    required this.fullName,
    required this.mobile,
    this.countryCode = '+971',
    this.username,
    required this.termsAccepted,
  });
  final String fullName, mobile, countryCode;
  final String? username;
  final bool termsAccepted;
  @override
  List<Object?> get props => [
    fullName,
    mobile,
    countryCode,
    username,
    termsAccepted,
  ];
}

final class VerifySignUpOtpEvent extends AuthEvent {
  final String verificationId;
  final String otp;
  final String countryCode;

  const VerifySignUpOtpEvent({
    required this.verificationId,
    required this.otp,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [verificationId, otp, countryCode];
}

final class ResendSignUpOtpEvent extends AuthEvent {
  const ResendSignUpOtpEvent(this.verificationId);
  final String verificationId;
  @override
  List<Object?> get props => [verificationId];
}

final class ForgotPasscodeEvent extends AuthEvent {
  const ForgotPasscodeEvent({
    required this.contact,
    required this.isEmail,
    this.countryCode,
  });
  final String contact;
  final bool isEmail;
  final String? countryCode;
  @override
  List<Object?> get props => [contact, isEmail, countryCode];
}

final class VerifyPasscodeOtpEvent extends AuthEvent {
  const VerifyPasscodeOtpEvent({
    required this.verificationId,
    required this.contact,
    required this.otp,
    this.countryCode,
  });
  final String verificationId;
  final String contact;
  final String otp;
  final String? countryCode;
  @override
  List<Object?> get props => [verificationId, contact, otp, countryCode];
}

final class ResetPasscodeEvent extends AuthEvent {
  const ResetPasscodeEvent({
    required this.resetToken,
    required this.newPasscode,
  });
  final String resetToken, newPasscode;
  @override
  List<Object?> get props => [resetToken, newPasscode];
}

final class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

final class CheckCachedUserEvent extends AuthEvent {
  const CheckCachedUserEvent();
}
