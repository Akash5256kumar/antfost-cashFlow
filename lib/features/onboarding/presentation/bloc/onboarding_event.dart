import 'package:equatable/equatable.dart';

/// Sealed base class for all onboarding-related BLoC events.
sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Load onboarding
// ---------------------------------------------------------------------------

/// Dispatched to load the onboarding pages from the repository.
final class LoadOnboardingEvent extends OnboardingEvent {
  const LoadOnboardingEvent();
}

// ---------------------------------------------------------------------------
// Next page
// ---------------------------------------------------------------------------

/// Dispatched when the user taps "Next" / "Continue" to advance one slide.
final class NextPageEvent extends OnboardingEvent {
  const NextPageEvent();
}

// ---------------------------------------------------------------------------
// Previous page
// ---------------------------------------------------------------------------

/// Dispatched when the user navigates back to the previous slide.
final class PreviousPageEvent extends OnboardingEvent {
  const PreviousPageEvent();
}

// ---------------------------------------------------------------------------
// Go to page
// ---------------------------------------------------------------------------

/// Dispatched when the user taps a page-indicator dot to jump directly to
/// a specific slide at [index].
final class GoToPageEvent extends OnboardingEvent {
  /// Zero-based index of the target slide.
  final int index;

  const GoToPageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// ---------------------------------------------------------------------------
// Complete onboarding
// ---------------------------------------------------------------------------

/// Dispatched when the user taps "Get Started" on the last slide.
final class CompleteOnboardingEvent extends OnboardingEvent {
  const CompleteOnboardingEvent();
}
