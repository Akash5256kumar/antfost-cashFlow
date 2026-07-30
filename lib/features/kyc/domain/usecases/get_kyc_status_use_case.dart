import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/kyc_status.dart';
import '../repositories/kyc_repository.dart';

/// Use case that retrieves the current KYC status for the authenticated user.
class GetKycStatusUseCase implements UseCase<KycStatus, NoParams> {
  final KycRepository repository;

  const GetKycStatusUseCase(this.repository);

  @override
  Future<Either<Failure, KycStatus>> call(NoParams params) {
    return repository.getKycStatus();
  }
}
