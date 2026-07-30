import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

/// Contract for the profile feature data layer.
abstract class ProfileRepository {
  /// Fetches the current user's profile or returns a [Failure].
  Future<Either<Failure, UserProfile>> getProfile();

  /// Persists profile changes.
  ///
  /// Returns `true` on success or a [Failure].
  Future<Either<Failure, bool>> updateProfile(UserProfile profile);
}
