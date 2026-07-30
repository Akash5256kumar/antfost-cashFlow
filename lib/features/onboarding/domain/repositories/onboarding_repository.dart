import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/onboarding_page.dart';

/// Contract for the onboarding feature repository.
abstract class OnboardingRepository {
  /// Returns the list of static onboarding slides.
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages();

  /// Persists a flag indicating the user has completed onboarding.
  /// Returns `true` on success.
  Future<Either<Failure, bool>> markOnboardingComplete();

  /// Returns `true` if the user has previously completed onboarding.
  Future<Either<Failure, bool>> isOnboardingComplete();
}
