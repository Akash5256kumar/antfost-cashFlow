import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Retrieves the locally cached [User], if any.
/// Returns [Right(null)] when no user is cached (not signed in).
class GetCachedUserUseCase extends UseCase<User?, NoParams> {
  final AuthRepository repository;

  const GetCachedUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.getCachedUser();
  }
}
