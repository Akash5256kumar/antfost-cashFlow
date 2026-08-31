import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Authenticates the user with a contact identifier and passcode.
class SignInUseCase extends UseCase<User, SignInParams> {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    // Input validation (removed empty contact check)

    return repository.signIn(
      contact: params.contact.trim(),
      passcode: params.passcode.trim(),
      isEmail: params.isEmail,
    );
  }
}

/// Parameters for [SignInUseCase].
class SignInParams extends Equatable {
  final String contact;
  final String passcode;
  final bool isEmail;

  const SignInParams({
    required this.contact,
    required this.passcode,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, passcode, isEmail];
}
