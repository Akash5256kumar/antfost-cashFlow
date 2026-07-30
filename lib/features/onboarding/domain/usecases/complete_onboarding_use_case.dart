import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// Use case that marks the onboarding flow as completed for the current user.
class CompleteOnboardingUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  const CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.markOnboardingComplete();
  }
}
