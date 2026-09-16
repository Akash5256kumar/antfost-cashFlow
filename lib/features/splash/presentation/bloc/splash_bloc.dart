import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_app_launch_state_use_case.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// Orchestrates the splash screen initialisation sequence.
///
/// Emits [SplashLoading] while the session is being resolved, then
/// transitions to [SplashReady] with the appropriate destination or
/// [SplashError] on failure.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetAppLaunchStateUseCase getAppLaunchStateUseCase;

  SplashBloc({required this.getAppLaunchStateUseCase})
    : super(const SplashInitial()) {
    on<InitializeSplashEvent>(_onInitialize);
  }

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  /// Kicks off the splash delay and session check, then routes accordingly.
  Future<void> _onInitialize(
    InitializeSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    final result = await getAppLaunchStateUseCase(const NoParams());

    result.fold(
      (failure) => emit(SplashError(_mapFailureToMessage(failure))),
      (launchState) => emit(
        SplashReady(
          launchState.destination,
          verificationUnderReview: launchState.verificationUnderReview,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Converts a [Failure] into a user-facing error message.
  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) return failure.message;
    return 'Something went wrong. Please try again.';
  }
}
