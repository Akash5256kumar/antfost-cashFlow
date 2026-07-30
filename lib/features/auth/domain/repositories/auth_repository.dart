import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Contract that the data layer must fulfill.
/// All methods return [Either] so callers handle failures explicitly.
abstract class AuthRepository {
  /// Sign in with [contact] (email or phone) and [passcode].
  /// [isEmail] indicates whether [contact] is an email address.
  Future<Either<Failure, User>> signIn({
    required String contact,
    required String passcode,
    required bool isEmail,
  });

  /// Register a new user account.
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String passcode,
  });

  /// Verify a one-time password sent to [contact].
  Future<Either<Failure, bool>> verifyOtp({
    required String contact,
    required String otp,
    required bool isEmail,
  });

  /// Initiate the forgot-passcode flow — sends OTP to [contact].
  Future<Either<Failure, bool>> forgotPasscode({
    required String contact,
    required bool isEmail,
  });

  /// Reset the passcode after OTP verification.
  Future<Either<Failure, bool>> resetPasscode({
    required String contact,
    required String otp,
    required String newPasscode,
  });

  /// Sign out the currently authenticated user.
  Future<Either<Failure, bool>> signOut();

  /// Return the locally cached [User], or null if none exists.
  Future<Either<Failure, User?>> getCachedUser();
}
