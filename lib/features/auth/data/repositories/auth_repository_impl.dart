import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.secureStorage,
    required this.apiClient,
  });
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final SecureStorageService secureStorage;
  final ApiClient apiClient;

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required String usernameOrMobile,
    required String password,
  }) => _online(() async {
    final session = await remoteDataSource.signIn(
      usernameOrMobile: usernameOrMobile,
      password: password,
    );
    await _saveSession(session);
    return session;
  });
  @override
  Future<Either<Failure, OtpChallenge>> signUpBusiness({
    required String companyName,
    required String username,
    required String registeredMobile,
    required String password,
  }) => _online(
    () => remoteDataSource.signUpBusiness(
      companyName: companyName,
      username: username,
      registeredMobile: registeredMobile,
      password: password,
    ),
  );
  @override
  Future<Either<Failure, OtpChallenge>> signUpIndividual({
    required String fullName,
    required String mobile,
    required String username,
    required String password,
    required bool termsAccepted,
  }) => _online(
    () => remoteDataSource.signUpIndividual(
      fullName: fullName,
      mobile: mobile,
      username: username,
      password: password,
      termsAccepted: termsAccepted,
    ),
  );
  @override
  Future<Either<Failure, AuthSession>> verifySignUpOtp({
    required String verificationId,
    required String otp,
  }) => _online(() async {
    final session = await remoteDataSource.verifySignUpOtp(
      verificationId: verificationId,
      otp: otp,
    );
    await _saveSession(session);
    return session;
  });
  @override
  Future<Either<Failure, OtpChallenge>> resendSignUpOtp({
    required String verificationId,
  }) => _online(
    () => remoteDataSource.resendSignUpOtp(verificationId: verificationId),
  );
  @override
  Future<Either<Failure, OtpChallenge>> forgotPasscode({
    required String contact,
    required bool isEmail,
  }) => _online(
    () => remoteDataSource.forgotPasscode(contact: contact, isEmail: isEmail),
  );
  @override
  Future<Either<Failure, PasswordResetVerification>> verifyPasscodeOtp({
    required String verificationId,
    required String contact,
    required String otp,
  }) => _online(
    () => remoteDataSource.verifyPasscodeOtp(
      verificationId: verificationId,
      contact: contact,
      otp: otp,
    ),
  );
  @override
  Future<Either<Failure, void>> resetPasscode({
    required String resetToken,
    required String newPasscode,
  }) => _online(
    () => remoteDataSource.resetPasscode(
      resetToken: resetToken,
      newPasscode: newPasscode,
    ),
  );
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final token = await secureStorage.readRefreshToken();
      if (await networkInfo.isConnected && token != null)
        await remoteDataSource.signOut(refreshToken: token);
      await localDataSource.clearCachedUser();
      await secureStorage.clearTokens();
      apiClient.clearAccessToken();
      return const Right(null);
    } catch (e) {
      return Left(_failure(e));
    }
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      return Right(await localDataSource.getCachedUser());
    } on CacheException {
      return const Right(null);
    } catch (e) {
      return Left(_failure(e));
    }
  }

  Future<void> _saveSession(AuthSession session) async {
    await secureStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    apiClient.setAccessToken(session.accessToken);
    await localDataSource.cacheUser(UserModel.fromEntity(session.user));
  }

  Future<Either<Failure, T>> _online<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await action());
    } catch (e) {
      return Left(_failure(e));
    }
  }

  Failure _failure(Object e) => e is AuthException
      ? AuthFailure(e.message)
      : e is NetworkException
      ? NetworkFailure(e.message)
      : e is TimeoutException
      ? NetworkFailure(e.message)
      : e is ServerException
      ? ServerFailure(e.message)
      : const UnexpectedFailure();
}
