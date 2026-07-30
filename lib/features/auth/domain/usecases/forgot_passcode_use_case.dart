import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Initiates the forgot-passcode flow by sending an OTP to [contact].
class ForgotPasscodeUseCase extends UseCase<bool, ForgotPasscodeParams> {
  final AuthRepository repository;

  const ForgotPasscodeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ForgotPasscodeParams params) async {
    if (params.contact.trim().isEmpty) {
      return Left(
        ValidationFailure(
          params.isEmail ? 'Email is required.' : 'Phone number is required.',
        ),
      );
    }

    return repository.forgotPasscode(
      contact: params.contact.trim(),
      isEmail: params.isEmail,
    );
  }
}

/// Parameters for [ForgotPasscodeUseCase].
class ForgotPasscodeParams extends Equatable {
  final String contact;
  final bool isEmail;

  const ForgotPasscodeParams({
    required this.contact,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, isEmail];
}
