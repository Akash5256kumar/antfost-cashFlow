import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_data_source.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/notification_model.dart';

/// Concrete implementation of [NotificationsRepository].
///
/// Strategy:
/// - getNotifications — online: remote → cache → Right(list);
///                      offline: cache → Right(list) or Left(NetworkFailure)
/// - markAsRead / markAllAsRead — update in-memory local cache immediately
///   (no network call needed for the mock layer).
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final List<AppNotificationModel> models =
            await remoteDataSource.getNotifications();
        await localDataSource.cacheNotifications(models);
        return Right(models);
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
        final List<AppNotificationModel> cached =
            await localDataSource.getCachedNotifications();
        return Right(cached);
      } on CacheException {
        return const Left(NetworkFailure());
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead(String notificationId) async {
    // For the mock layer: update local in-memory state without a network call.
    try {
      await localDataSource.markAsRead(notificationId);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    // For the mock layer: update local in-memory state without a network call.
    try {
      await localDataSource.markAllAsRead();
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
