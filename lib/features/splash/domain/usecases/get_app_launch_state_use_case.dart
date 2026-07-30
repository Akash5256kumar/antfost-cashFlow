import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_launch_state.dart';
import '../repositories/splash_repository.dart';

/// Use case that determines the app's initial navigation destination.
class GetAppLaunchStateUseCase implements UseCase<AppLaunchState, NoParams> {
  final SplashRepository repository;

  const GetAppLaunchStateUseCase(this.repository);

  @override
  Future<Either<Failure, AppLaunchState>> call(NoParams params) {
    return repository.getAppLaunchState();
  }
}
