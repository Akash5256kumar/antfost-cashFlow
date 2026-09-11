import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_flow.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> signIn({
    required String usernameOrMobile,
    required String password,
  });
  Future<Either<Failure, OtpChallenge>> signUpBusiness({
    required String companyName,
    required String username,
    required String registeredMobile,
    required String password,
  });
  Future<Either<Failure, OtpChallenge>> signUpIndividual({
    required String fullName,
    required String mobile,
    required String username,
    required String password,
    required bool termsAccepted,
  });
  Future<Either<Failure, AuthSession>> verifySignUpOtp({
    required String verificationId,
    required String otp,
  });
  Future<Either<Failure, OtpChallenge>> resendSignUpOtp({
    required String verificationId,
  });
  Future<Either<Failure, OtpChallenge>> forgotPasscode({
    required String contact,
    required bool isEmail,
  });
  Future<Either<Failure, PasswordResetVerification>> verifyPasscodeOtp({
    required String verificationId,
    required String contact,
    required String otp,
  });
  Future<Either<Failure, void>> resetPasscode({
    required String resetToken,
    required String newPasscode,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCachedUser();
}
