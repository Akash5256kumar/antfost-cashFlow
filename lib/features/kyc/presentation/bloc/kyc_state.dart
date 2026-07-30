import 'package:equatable/equatable.dart';

import '../../domain/entities/kyc_status.dart';

/// Sealed base class for all KYC-related BLoC states.
sealed class KycState extends Equatable {
  const KycState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Initial
// ---------------------------------------------------------------------------

/// Default state before any KYC event has been processed.
final class KycInitial extends KycState {
  const KycInitial();
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Emitted while the KYC status is being fetched from the repository.
final class KycLoading extends KycState {
  const KycLoading();
}

// ---------------------------------------------------------------------------
// Status loaded
// ---------------------------------------------------------------------------

/// Emitted once the KYC status has been successfully retrieved.
final class KycStatusLoaded extends KycState {
  /// The retrieved KYC status entity.
  final KycStatus status;

  const KycStatusLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

// ---------------------------------------------------------------------------
// Submitting
// ---------------------------------------------------------------------------

/// Emitted while the KYC application is being submitted to the repository.
final class KycSubmitting extends KycState {
  const KycSubmitting();
}

// ---------------------------------------------------------------------------
// Submitted
// ---------------------------------------------------------------------------

/// Emitted once the KYC application has been successfully submitted.
final class KycSubmitted extends KycState {
  const KycSubmitted();
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Emitted when any KYC operation fails.
final class KycError extends KycState {
  /// Human-readable error message to display to the user.
  final String message;

  const KycError(this.message);

  @override
  List<Object?> get props => [message];
}
