import 'package:equatable/equatable.dart';

/// Represents the possible verification states for a user's KYC submission.
enum KycVerificationStatus {
  /// This account does not need a KYC submission.
  notRequired,

  /// User has not yet submitted any KYC documents.
  notSubmitted,

  /// Some KYC information has been submitted but more details are required.
  partiallySubmitted,

  /// KYC documents have been submitted and are awaiting review.
  pending,

  /// KYC has been reviewed and approved.
  approved,

  /// KYC has been reviewed and rejected.
  rejected,
}

/// A document row returned by GET /kyc/status.
class KycStatusDocument extends Equatable {
  const KycStatusDocument({
    required this.type,
    required this.label,
    required this.required,
    required this.status,
    this.rejectionReason,
    this.uploadedAt,
  });

  final String type;
  final String label;
  final bool required;
  final String status;
  final String? rejectionReason;
  final String? uploadedAt;

  @override
  List<Object?> get props => [
    type,
    label,
    required,
    status,
    rejectionReason,
    uploadedAt,
  ];
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

  final String? estimatedReviewTime;
  final String? imageUrl;
  final bool? companyDetailsComplete;
  final List<String> companyMissingFields;
  final List<KycStatusDocument> documents;

  const KycStatus({
    required this.status,
    this.submittedAt,
    this.reviewedAt,
    this.rejectionReason,
    this.estimatedReviewTime,
    this.imageUrl,
    this.companyDetailsComplete,
    this.companyMissingFields = const [],
    this.documents = const [],
  });

  @override
  List<Object?> get props => [
    status,
    submittedAt,
    reviewedAt,
    rejectionReason,
    estimatedReviewTime,
    imageUrl,
    companyDetailsComplete,
    companyMissingFields,
    documents,
  ];
}
