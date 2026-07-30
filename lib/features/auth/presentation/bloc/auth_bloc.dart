import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/forgot_passcode_use_case.dart';
import '../../domain/usecases/get_cached_user_use_case.dart';
import '../../domain/usecases/reset_passcode_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Orchestrates all authentication flows.
/// Each [AuthEvent] is mapped to the appropriate use case; results are
/// translated into [AuthState] variants for the UI to react to.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ForgotPasscodeUseCase forgotPasscodeUseCase;
  final ResetPasscodeUseCase resetPasscodeUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.verifyOtpUseCase,
    required this.forgotPasscodeUseCase,
    required this.resetPasscodeUseCase,
    required this.signOutUseCase,
    required this.getCachedUserUseCase,
  }) : super(const AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ForgotPasscodeEvent>(_onForgotPasscode);
    on<ResetPasscodeEvent>(_onResetPasscode);
    on<SignOutEvent>(_onSignOut);
    on<CheckCachedUserEvent>(_onCheckCachedUser);
  }

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(
        contact: event.contact,
        passcode: event.passcode,
        isEmail: event.isEmail,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        company: event.company,
        passcode: event.passcode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      // After registration the app enters an OTP-verification step.
      (_) => emit(const AuthOtpSent()),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        contact: event.contact,
        otp: event.otp,
        isEmail: event.isEmail,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(const AuthOtpVerified()),
    );
  }

  Future<void> _onForgotPasscode(
    ForgotPasscodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await forgotPasscodeUseCase(
      ForgotPasscodeParams(
        contact: event.contact,
        isEmail: event.isEmail,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(const AuthOtpSent()),
    );
  }

  Future<void> _onResetPasscode(
    ResetPasscodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await resetPasscodeUseCase(
      ResetPasscodeParams(
        contact: event.contact,
        otp: event.otp,
        newPasscode: event.newPasscode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(const AuthOtpVerified()),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await signOutUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(const AuthSignedOut()),
    );
  }

  Future<void> _onCheckCachedUser(
    CheckCachedUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCachedUserUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(const AuthInitial());
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Converts a [Failure] into a user-facing error message.
  String _mapFailureToMessage(Failure failure) {
    return failure is NetworkFailure
        ? failure.message
        : failure is AuthFailure
            ? failure.message
            : failure is ValidationFailure
                ? failure.message
                : 'Something went wrong. Please try again.';
  }
}
