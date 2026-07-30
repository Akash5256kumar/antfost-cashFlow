import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete implementation of [AuthRepository].
/// Delegates to [AuthRemoteDataSource] when online,
/// and caches results via [AuthLocalDataSource].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ---------------------------------------------------------------------------
  // Sign in
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, User>> signIn({
    required String contact,
    required String passcode,
    required bool isEmail,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = await remoteDataSource.signIn(
        contact: contact,
        passcode: passcode,
        isEmail: isEmail,
      );
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Sign up
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String passcode,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = await remoteDataSource.signUp(
        name: name,
        email: email,
        phone: phone,
        company: company,
        passcode: passcode,
      );
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Verify OTP
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> verifyOtp({
    required String contact,
    required String otp,
    required bool isEmail,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.verifyOtp(
        contact: contact,
        otp: otp,
        isEmail: isEmail,
      );
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Forgot passcode
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> forgotPasscode({
    required String contact,
    required bool isEmail,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.forgotPasscode(
        contact: contact,
        isEmail: isEmail,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Reset passcode
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> resetPasscode({
    required String contact,
    required String otp,
    required String newPasscode,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.resetPasscode(
        contact: contact,
        otp: otp,
        newPasscode: newPasscode,
      );
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Sign out
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      // Attempt remote sign-out if online; clear local cache regardless.
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }
      await localDataSource.clearCachedUser();
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Get cached user
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel);
    } on CacheException catch (_) {
      // No cached user is a valid "not signed in" state — return null.
      return const Right(null);
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

}
