import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class SignInEvent extends AuthEvent {
  const SignInEvent({required this.usernameOrMobile, required this.password});
  final String usernameOrMobile;
  final String password;
  @override
  List<Object?> get props => [usernameOrMobile, password];
}

final class SignUpBusinessEvent extends AuthEvent {
  const SignUpBusinessEvent({
    required this.companyName,
    required this.username,
    required this.registeredMobile,
    required this.password,
  });
  final String companyName, username, registeredMobile, password;
  @override
  List<Object?> get props => [
    companyName,
    username,
    registeredMobile,
    password,
  ];
}

final class SignUpIndividualEvent extends AuthEvent {
  const SignUpIndividualEvent({
    required this.fullName,
    required this.mobile,
    required this.username,
    required this.password,
    required this.termsAccepted,
  });
  final String fullName, mobile, username, password;
  final bool termsAccepted;
  @override
  List<Object?> get props => [
    fullName,
    mobile,
    username,
    password,
    termsAccepted,
  ];
}

final class VerifySignUpOtpEvent extends AuthEvent {
  const VerifySignUpOtpEvent({required this.verificationId, required this.otp});
  final String verificationId, otp;
  @override
  List<Object?> get props => [verificationId, otp];
}

final class ResendSignUpOtpEvent extends AuthEvent {
  const ResendSignUpOtpEvent(this.verificationId);
  final String verificationId;
  @override
  List<Object?> get props => [verificationId];
}

final class ForgotPasscodeEvent extends AuthEvent {
  const ForgotPasscodeEvent({required this.contact, required this.isEmail});
  final String contact;
  final bool isEmail;
  @override
  List<Object?> get props => [contact, isEmail];
}

final class VerifyPasscodeOtpEvent extends AuthEvent {
  const VerifyPasscodeOtpEvent({
    required this.verificationId,
    required this.contact,
    required this.otp,
  });
  final String verificationId, contact, otp;
  @override
  List<Object?> get props => [verificationId, contact, otp];
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
