import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

/// Concrete implementation of [OnboardingRepository].
/// Onboarding content is entirely static and local — no network calls required.
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  const OnboardingRepositoryImpl({required this.localDataSource});

  // ---------------------------------------------------------------------------
  // Get onboarding pages
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<OnboardingPage>>> getOnboardingPages() async {
    try {
      final pages = await localDataSource.getOnboardingPages();
      return Right(pages);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Mark onboarding complete
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> markOnboardingComplete() async {
    try {
      await localDataSource.setOnboardingComplete();
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Check onboarding complete
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    try {
      final result = await localDataSource.isOnboardingComplete();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
