import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/complete_onboarding_use_case.dart';
import '../../domain/usecases/get_onboarding_pages_use_case.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Orchestrates the onboarding flow.
///
/// Maps [OnboardingEvent] subclasses to the appropriate use cases and updates
/// the active page index in response to navigation events.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingPagesUseCase getOnboardingPagesUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  OnboardingBloc({
    required this.getOnboardingPagesUseCase,
    required this.completeOnboardingUseCase,
  }) : super(const OnboardingInitial()) {
    on<LoadOnboardingEvent>(_onLoad);
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<GoToPageEvent>(_onGoToPage);
    on<CompleteOnboardingEvent>(_onComplete);
  }

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  /// Loads onboarding pages and emits [OnboardingLoaded] at index 0 or [OnboardingError].
  Future<void> _onLoad(
    LoadOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());

    final result = await getOnboardingPagesUseCase(const NoParams());

    result.fold(
      (failure) => emit(OnboardingError(_mapFailureToMessage(failure))),
      (pages) => emit(OnboardingLoaded(pages: pages, currentIndex: 0)),
    );
  }

  /// Advances to the next slide if the current state is [OnboardingLoaded].
  Future<void> _onNextPage(
    NextPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;

    final nextIndex = current.currentIndex + 1;
    if (nextIndex < current.pages.length) {
      emit(current.copyWith(currentIndex: nextIndex));
    }
  }

  /// Goes back to the previous slide if the current state is [OnboardingLoaded].
  Future<void> _onPreviousPage(
    PreviousPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;

    final prevIndex = current.currentIndex - 1;
    if (prevIndex >= 0) {
      emit(current.copyWith(currentIndex: prevIndex));
    }
  }

  /// Jumps directly to the slide at [event.index] if within bounds.
  Future<void> _onGoToPage(
    GoToPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;

    if (event.index >= 0 && event.index < current.pages.length) {
      emit(current.copyWith(currentIndex: event.index));
    }
  }

  /// Persists the completion flag and emits [OnboardingComplete] or [OnboardingError].
  Future<void> _onComplete(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = await completeOnboardingUseCase(const NoParams());

    result.fold(
      (failure) => emit(OnboardingError(_mapFailureToMessage(failure))),
      (_) => emit(const OnboardingComplete()),
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
