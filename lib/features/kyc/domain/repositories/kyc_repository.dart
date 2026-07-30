import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/kyc_document.dart';
import '../entities/kyc_status.dart';

/// Contract for the KYC feature repository.
/// All methods return [Either] to represent success or typed failure.
abstract class KycRepository {
  /// Fetches the current KYC verification status for the authenticated user.
  Future<Either<Failure, KycStatus>> getKycStatus();

  /// Submits KYC documents and personal information for verification.
  ///
  /// [documents]       — List of supporting documents to upload.
  /// [fullName]        — Full legal name of the applicant.
  /// [emiratesId]      — UAE Emirates ID number.
  /// [tradeListNumber] — Company trade license number.
  ///
  /// Returns `true` on a successful submission.
  Future<Either<Failure, bool>> submitKyc({
    required List<KycDocument> documents,
    required String fullName,
    required String emiratesId,
    required String tradeListNumber,
  });
}
