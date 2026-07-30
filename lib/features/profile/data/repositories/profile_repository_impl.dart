import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

/// Concrete implementation of [ProfileRepository].
///
/// Strategy:
/// - Online  → fetch/update via remote → cache result → return Right(data)
/// - Offline → try cache → return Right(cached) or Left(NetworkFailure)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final UserProfileModel model = await remoteDataSource.getProfile();
        await localDataSource.cacheProfile(model);
        return Right(model);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      try {
        final UserProfileModel cached =
            await localDataSource.getCachedProfile();
        return Right(cached);
      } on CacheException {
        return const Left(NetworkFailure());
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile(UserProfile profile) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final profileModel = UserProfileModel.fromEntity(profile);
      final success = await remoteDataSource.updateProfile(profileModel);
      if (success) {
        // Keep the local cache in sync after a successful update.
        await localDataSource.cacheProfile(profileModel);
      }
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
