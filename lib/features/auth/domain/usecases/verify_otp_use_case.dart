import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Verifies the one-time password submitted by the user.
class VerifyOtpUseCase extends UseCase<bool, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyOtpParams params) async {
    if (params.contact.trim().isEmpty) {
      return Left(
        ValidationFailure(
          params.isEmail ? 'Email is required.' : 'Phone number is required.',
        ),
      );
    }
    if (params.otp.trim().isEmpty) {
      return Left(const ValidationFailure('OTP is required.'));
    }
    if (params.otp.trim().length < 4) {
      return Left(const ValidationFailure('OTP must be at least 4 digits.'));
    }

    return repository.verifyOtp(
      contact: params.contact.trim(),
      otp: params.otp.trim(),
      isEmail: params.isEmail,
    );
  }
}

/// Parameters for [VerifyOtpUseCase].
class VerifyOtpParams extends Equatable {
  final String contact;
  final String otp;
  final bool isEmail;

  const VerifyOtpParams({
    required this.contact,
    required this.otp,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [contact, otp, isEmail];
}
