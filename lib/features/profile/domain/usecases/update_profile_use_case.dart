import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Parameters required to update a user profile.
class UpdateProfileParams extends Equatable {
  final UserProfile profile;

  const UpdateProfileParams(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Persists changes made to the user's profile.
class UpdateProfileUseCase implements UseCase<bool, UpdateProfileParams> {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.profile);
  }
}
