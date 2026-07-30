import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_launch_state.dart';

/// Contract for the splash feature repository.
abstract class SplashRepository {
  /// Determines the correct initial destination for the app based on
  /// cached session data and onboarding completion status.
  Future<Either<Failure, AppLaunchState>> getAppLaunchState();
}
