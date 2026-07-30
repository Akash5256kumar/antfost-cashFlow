import 'package:equatable/equatable.dart';

import '../../domain/entities/onboarding_page.dart';

/// Sealed base class for all onboarding-related BLoC states.
sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Initial
// ---------------------------------------------------------------------------

/// Default state before any onboarding event has been processed.
final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Emitted while the onboarding pages are being loaded.
final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

// ---------------------------------------------------------------------------
// Loaded
// ---------------------------------------------------------------------------

/// Emitted once the onboarding pages have been successfully retrieved.
final class OnboardingLoaded extends OnboardingState {
  /// The full list of onboarding slides.
  final List<OnboardingPage> pages;

  /// Zero-based index of the currently visible slide.
  final int currentIndex;

  const OnboardingLoaded({
    required this.pages,
    required this.currentIndex,
  });

  /// Returns a copy with an updated [currentIndex].
  OnboardingLoaded copyWith({int? currentIndex}) {
    return OnboardingLoaded(
      pages: pages,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [pages, currentIndex];
}

// ---------------------------------------------------------------------------
// Complete
// ---------------------------------------------------------------------------

/// Emitted once the user has finished the onboarding flow.
final class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Emitted when any onboarding operation fails.
final class OnboardingError extends OnboardingState {
  /// Human-readable error message to display to the user.
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
