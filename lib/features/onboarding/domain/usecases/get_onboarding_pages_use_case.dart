import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/onboarding_page.dart';
import '../repositories/onboarding_repository.dart';

/// Use case that retrieves the list of onboarding slides.
class GetOnboardingPagesUseCase
    implements UseCase<List<OnboardingPage>, NoParams> {
  final OnboardingRepository repository;

  const GetOnboardingPagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<OnboardingPage>>> call(NoParams params) {
    return repository.getOnboardingPages();
  }
}
