import '../../domain/entities/kyc_status.dart';

/// Data-layer representation of [KycStatus].
/// Handles JSON serialisation / deserialisation and extends the domain entity.
class KycStatusModel extends KycStatus {
  const KycStatusModel({
    required super.status,
    super.submittedAt,
    super.reviewedAt,
    super.rejectionReason,
  });

  // ---------------------------------------------------------------------------
  // Enum helpers
  // ---------------------------------------------------------------------------

  /// Converts a [KycVerificationStatus] value to its JSON string representation.
  static String _statusToString(KycVerificationStatus status) {
    switch (status) {
      case KycVerificationStatus.notSubmitted:
        return 'not_submitted';
      case KycVerificationStatus.pending:
        return 'pending';
      case KycVerificationStatus.approved:
        return 'approved';
      case KycVerificationStatus.rejected:
        return 'rejected';
    }
  }

  /// Parses a JSON string into a [KycVerificationStatus] enum value.
  /// Defaults to [KycVerificationStatus.notSubmitted] for unknown values.
  static KycVerificationStatus _statusFromString(String? value) {
    switch (value) {
      case 'pending':
        return KycVerificationStatus.pending;
      case 'approved':
        return KycVerificationStatus.approved;
      case 'rejected':
        return KycVerificationStatus.rejected;
      case 'not_submitted':
      default:
        return KycVerificationStatus.notSubmitted;
    }
  }

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Deserialises a [KycStatusModel] from a JSON map returned by the remote API.
  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    return KycStatusModel(
      status: _statusFromString(json['status'] as String?),
      submittedAt: json['submitted_at'] as String?,
      reviewedAt: json['reviewed_at'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Promotes a domain [KycStatus] entity to a [KycStatusModel].
  factory KycStatusModel.fromEntity(KycStatus entity) {
    return KycStatusModel(
      status: entity.status,
      submittedAt: entity.submittedAt,
      reviewedAt: entity.reviewedAt,
      rejectionReason: entity.rejectionReason,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a JSON map suitable for caching or the remote API.
  Map<String, dynamic> toJson() {
    return {
      'status': _statusToString(status),
      'submitted_at': submittedAt,
      'reviewed_at': reviewedAt,
      'rejection_reason': rejectionReason,
    };
  }
}
