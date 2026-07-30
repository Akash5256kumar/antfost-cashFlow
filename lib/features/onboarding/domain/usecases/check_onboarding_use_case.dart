import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// Use case that checks whether the user has already completed onboarding.
class CheckOnboardingUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  const CheckOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isOnboardingComplete();
  }
}
