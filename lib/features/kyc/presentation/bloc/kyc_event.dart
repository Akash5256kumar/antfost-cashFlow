import 'package:equatable/equatable.dart';

import '../../domain/entities/kyc_document.dart';

/// Sealed base class for all KYC-related BLoC events.
sealed class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Fetch KYC status
// ---------------------------------------------------------------------------

/// Dispatched to load the current KYC verification status from the repository.
final class FetchKycStatusEvent extends KycEvent {
  const FetchKycStatusEvent();
}

// ---------------------------------------------------------------------------
// Submit KYC
// ---------------------------------------------------------------------------

/// Dispatched when the user submits their KYC documents and personal details.
final class SubmitKycEvent extends KycEvent {
  /// Supporting documents to be uploaded.
  final List<KycDocument> documents;

  /// Full legal name of the applicant.
  final String fullName;

  /// UAE Emirates ID number.
  final String emiratesId;

  /// Company trade license number.
  final String tradeListNumber;

  const SubmitKycEvent({
    required this.documents,
    required this.fullName,
    required this.emiratesId,
    required this.tradeListNumber,
  });

  @override
  List<Object?> get props => [documents, fullName, emiratesId, tradeListNumber];
}

// ---------------------------------------------------------------------------
// Retry
// ---------------------------------------------------------------------------

/// Dispatched to retry the last failed KYC operation (re-fetches status).
final class RetryKycEvent extends KycEvent {
  const RetryKycEvent();
}
