import 'package:equatable/equatable.dart';

/// Represents the possible verification states for a user's KYC submission.
enum KycVerificationStatus {
  /// User has not yet submitted any KYC documents.
  notSubmitted,

  /// KYC documents have been submitted and are awaiting review.
  pending,

  /// KYC has been reviewed and approved.
  approved,

  /// KYC has been reviewed and rejected.
  rejected,
}

/// Domain entity representing the current KYC verification status of a user.
class KycStatus extends Equatable {
  /// The current verification status.
  final KycVerificationStatus status;

  /// ISO-formatted timestamp when the KYC was submitted (nullable until submitted).
  final String? submittedAt;

  /// ISO-formatted timestamp when the KYC was reviewed (nullable until reviewed).
  final String? reviewedAt;

  /// Human-readable reason provided when status is [KycVerificationStatus.rejected].
  final String? rejectionReason;

  const KycStatus({
    required this.status,
    this.submittedAt,
    this.reviewedAt,
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [status, submittedAt, reviewedAt, rejectionReason];
}
