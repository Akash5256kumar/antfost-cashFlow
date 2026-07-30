import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Registers a new user account and returns the created [User].
class SignUpUseCase extends UseCase<User, SignUpParams> {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    // Input validation
    if (params.name.trim().isEmpty) {
      return Left(const ValidationFailure('Name is required.'));
    }
    if (params.email.trim().isEmpty) {
      return Left(const ValidationFailure('Email is required.'));
    }
    if (params.phone.trim().isEmpty) {
      return Left(const ValidationFailure('Phone number is required.'));
    }
    if (params.company.trim().isEmpty) {
      return Left(const ValidationFailure('Company name is required.'));
    }
    if (params.passcode.trim().isEmpty) {
      return Left(const ValidationFailure('Passcode is required.'));
    }
    if (params.passcode.trim().length < 6) {
      return Left(
        const ValidationFailure('Passcode must be at least 6 characters.'),
      );
    }

    return repository.signUp(
      name: params.name.trim(),
      email: params.email.trim(),
      phone: params.phone.trim(),
      company: params.company.trim(),
      passcode: params.passcode.trim(),
    );
  }
}

/// Parameters for [SignUpUseCase].
class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String company;
  final String passcode;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.passcode,
  });

  @override
  List<Object?> get props => [name, email, phone, company, passcode];
}
