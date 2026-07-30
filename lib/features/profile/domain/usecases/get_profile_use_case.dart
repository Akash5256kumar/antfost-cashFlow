import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Fetches the authenticated user's profile.
class GetProfileUseCase implements UseCase<UserProfile, NoParams> {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return repository.getProfile();
  }
}
