import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/entities/user.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final User user;
  @override
  List<Object?> get props => [user];
}

final class AuthOtpSent extends AuthState {
  const AuthOtpSent(this.challenge);
  final OtpChallenge challenge;
  @override
  List<Object?> get props => [challenge];
}

final class AuthOtpVerified extends AuthState {
  const AuthOtpVerified(this.session);
  final AuthSession session;
  @override
  List<Object?> get props => [session];
}

final class AuthResetTokenReady extends AuthState {
  const AuthResetTokenReady(this.resetToken);
  final String resetToken;
  @override
  List<Object?> get props => [resetToken];
}

final class AuthPasscodeReset extends AuthState {
  const AuthPasscodeReset();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
