import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_launch_state.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_data_source.dart';

/// Concrete implementation of [SplashRepository].
/// Splash routing is determined entirely from local/cached data — no
/// network call is required during splash initialisation.
class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  const SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppLaunchState>> getAppLaunchState() async {
    try {
      final launchState = await localDataSource.getAppLaunchState();
      return Right(launchState);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
