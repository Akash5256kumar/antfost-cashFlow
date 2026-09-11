import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthInitial()) {
    on<SignInEvent>(_signIn);
    on<SignUpBusinessEvent>(_business);
    on<SignUpIndividualEvent>(_individual);
    on<VerifySignUpOtpEvent>(_verifySignup);
    on<ResendSignUpOtpEvent>(_resend);
    on<ForgotPasscodeEvent>(_forgot);
    on<VerifyPasscodeOtpEvent>(_verifyReset);
    on<ResetPasscodeEvent>(_reset);
    on<SignOutEvent>(_signOut);
    on<CheckCachedUserEvent>(_cached);
  }
  final AuthRepository _repo;
  Future<void> _run<T>(
    Emitter<AuthState> e,
    Future<dynamic> Function() f,
    AuthState Function(dynamic) ok,
  ) async {
    e(const AuthLoading());
    final r = await f();
    r.fold((x) => e(AuthError(_message(x))), (x) => e(ok(x)));
  }

  Future<void> _signIn(SignInEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.signIn(
      usernameOrMobile: x.usernameOrMobile,
      password: x.password,
    ),
    (v) => AuthSuccess(v.user),
  );
  Future<void> _business(SignUpBusinessEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.signUpBusiness(
      companyName: x.companyName,
      username: x.username,
      registeredMobile: x.registeredMobile,
      password: x.password,
    ),
    (v) => AuthOtpSent(v),
  );
  Future<void> _individual(SignUpIndividualEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.signUpIndividual(
          fullName: x.fullName,
          mobile: x.mobile,
          username: x.username,
          password: x.password,
          termsAccepted: x.termsAccepted,
        ),
        (v) => AuthOtpSent(v),
      );
  Future<void> _verifySignup(VerifySignUpOtpEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () =>
            _repo.verifySignUpOtp(verificationId: x.verificationId, otp: x.otp),
        (v) => AuthOtpVerified(v),
      );
  Future<void> _resend(ResendSignUpOtpEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.resendSignUpOtp(verificationId: x.verificationId),
    (v) => AuthOtpSent(v),
  );
  Future<void> _forgot(ForgotPasscodeEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.forgotPasscode(contact: x.contact, isEmail: x.isEmail),
    (v) => AuthOtpSent(v),
  );
  Future<void> _verifyReset(VerifyPasscodeOtpEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.verifyPasscodeOtp(
          verificationId: x.verificationId,
          contact: x.contact,
          otp: x.otp,
        ),
        (v) => AuthResetTokenReady(v.resetToken),
      );
  Future<void> _reset(ResetPasscodeEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.resetPasscode(
      resetToken: x.resetToken,
      newPasscode: x.newPasscode,
    ),
    (_) => const AuthPasscodeReset(),
  );
  Future<void> _signOut(SignOutEvent x, Emitter<AuthState> e) =>
      _run(e, () => _repo.signOut(), (_) => const AuthSignedOut());
  Future<void> _cached(CheckCachedUserEvent x, Emitter<AuthState> e) async {
    final r = await _repo.getCachedUser();
    r.fold(
      (f) => e(AuthError(_message(f))),
      (u) => e(u == null ? const AuthInitial() : AuthSuccess(u)),
    );
  }

  String _message(Failure f) => f.message;
}
