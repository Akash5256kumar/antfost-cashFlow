import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Resets the user's passcode after successful OTP verification.
class ResetPasscodeUseCase extends UseCase<bool, ResetPasscodeParams> {
  final AuthRepository repository;

  const ResetPasscodeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasscodeParams params) async {
    if (params.contact.trim().isEmpty) {
      return Left(const ValidationFailure('Contact is required.'));
    }
    if (params.otp.trim().isEmpty) {
      return Left(const ValidationFailure('OTP is required.'));
    }
    if (params.newPasscode.trim().isEmpty) {
      return Left(const ValidationFailure('New passcode is required.'));
    }
    if (params.newPasscode.trim().length < 6) {
      return Left(
        const ValidationFailure('Passcode must be at least 6 characters.'),
      );
    }

    return repository.resetPasscode(
      contact: params.contact.trim(),
      otp: params.otp.trim(),
      newPasscode: params.newPasscode.trim(),
    );
  }
}

/// Parameters for [ResetPasscodeUseCase].
class ResetPasscodeParams extends Equatable {
  final String contact;
  final String otp;
  final String newPasscode;

  const ResetPasscodeParams({
    required this.contact,
    required this.otp,
    required this.newPasscode,
  });

  @override
  List<Object?> get props => [contact, otp, newPasscode];
}
