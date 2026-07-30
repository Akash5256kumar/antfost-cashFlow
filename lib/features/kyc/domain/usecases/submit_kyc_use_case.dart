import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/kyc_document.dart';
import '../repositories/kyc_repository.dart';

/// Parameters required to submit a KYC application.
class SubmitKycParams extends Equatable {
  /// Supporting documents to upload (e.g. Emirates ID, trade license).
  final List<KycDocument> documents;

  /// Full legal name of the applicant.
  final String fullName;

  /// UAE Emirates ID number.
  final String emiratesId;

  /// Company trade license number.
  final String tradeListNumber;

  const SubmitKycParams({
    required this.documents,
    required this.fullName,
    required this.emiratesId,
    required this.tradeListNumber,
  });

  @override
  List<Object?> get props => [documents, fullName, emiratesId, tradeListNumber];
}

/// Use case that validates and submits the KYC application to the repository.
///
/// Validation rules:
///   - [fullName], [emiratesId], and [tradeListNumber] must not be empty.
class SubmitKycUseCase implements UseCase<bool, SubmitKycParams> {
  final KycRepository repository;

  const SubmitKycUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubmitKycParams params) {
    // Validate required string fields before delegating to the repository.
    if (params.fullName.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Full name is required.')),
      );
    }
    if (params.emiratesId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Emirates ID is required.')),
      );
    }
    if (params.tradeListNumber.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Trade license number is required.')),
      );
    }

    return repository.submitKyc(
      documents: params.documents,
      fullName: params.fullName,
      emiratesId: params.emiratesId,
      tradeListNumber: params.tradeListNumber,
    );
  }
}
