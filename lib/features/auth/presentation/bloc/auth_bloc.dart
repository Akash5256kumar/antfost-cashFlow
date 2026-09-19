import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/notifications/firebase_notification_service.dart';
import '../../../../core/services/app_demo_service.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthInitial()) {
    on<SignInEvent>(_signIn);
    on<VerifySignInOtpEvent>(_verifySignInOtp);
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
    r.fold((x) => e(_error(x)), (x) => e(ok(x)));
  }

  Future<void> _signIn(SignInEvent x, Emitter<AuthState> e) => _run(
        e,
        () => _repo.signIn(
          usernameOrMobile: x.usernameOrMobile,
          countryCode: x.countryCode,
        ),
        (v) => AuthOtpSent(v),
      );

  Future<void> _verifySignInOtp(VerifySignInOtpEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.verifySignInOtp(
          verificationId: x.verificationId,
          otp: x.otp,
        ),
        (v) {
          AppDemoService.setDemoMode(false);
          FirebaseNotificationService.instance.registerDeviceToken();
          return AuthSuccess(v.user, nextStep: v.nextStep);
        },
      );

  Future<void> _business(SignUpBusinessEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.signUpBusiness(
      companyName: x.companyName,
      username: x.username,
      registeredMobile: x.registeredMobile,
      countryCode: x.countryCode,
      email: x.email,
    ),
    (v) => AuthOtpSent(v),
  );

  Future<void> _individual(SignUpIndividualEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.signUpIndividual(
          fullName: x.fullName,
          mobile: x.mobile,
          countryCode: x.countryCode,
          username: x.username,
          termsAccepted: x.termsAccepted,
        ),
        (v) => AuthOtpSent(v),
      );
  Future<void> _verifySignup(VerifySignUpOtpEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.verifySignUpOtp(
          verificationId: x.verificationId,
          otp: x.otp,
          countryCode: x.countryCode,
        ),
        (v) {
          AppDemoService.setDemoMode(false);
          FirebaseNotificationService.instance.registerDeviceToken();
          return AuthOtpVerified(v);
        },
      );
  Future<void> _resend(ResendSignUpOtpEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.resendSignUpOtp(verificationId: x.verificationId),
    (v) => AuthOtpSent(v),
  );
  Future<void> _forgot(ForgotPasscodeEvent x, Emitter<AuthState> e) => _run(
    e,
    () => _repo.forgotPasscode(
      contact: x.contact, 
      isEmail: x.isEmail,
      countryCode: x.countryCode,
    ),
    (v) => AuthOtpSent(v),
  );
  Future<void> _verifyReset(VerifyPasscodeOtpEvent x, Emitter<AuthState> e) =>
      _run(
        e,
        () => _repo.verifyPasscodeOtp(
          verificationId: x.verificationId,
          contact: x.contact,
          otp: x.otp,
          countryCode: x.countryCode,
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
      _run(e, () async {
        AppDemoService.setDemoMode(false);
        await FirebaseNotificationService.instance.removeDeviceToken();
        return _repo.signOut();
      }, (_) => const AuthSignedOut());
  Future<void> _cached(CheckCachedUserEvent x, Emitter<AuthState> e) async {
    final r = await _repo.getCachedUser();
    r.fold(
      (f) => e(_error(f)),
      (cachedUser) {
        if (cachedUser == null) {
          e(const AuthInitial());
        } else {
          AppDemoService.setDemoMode(false);
          FirebaseNotificationService.instance.registerDeviceToken();
          e(AuthSuccess(cachedUser));
        }
      },
    );
  }

  AuthState _error(Failure f) =>
      AuthError(f.message, f is ValidationFailure ? f.fields : const {});
}
