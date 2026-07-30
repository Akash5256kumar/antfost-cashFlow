import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Signs out the currently authenticated user.
/// Uses [NoParams] as there are no inputs required.
class SignOutUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.signOut();
  }
}
