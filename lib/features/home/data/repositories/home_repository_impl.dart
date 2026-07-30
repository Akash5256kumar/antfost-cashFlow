import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_data_model.dart';

/// Concrete implementation of [HomeRepository].
///
/// Strategy:
/// - Online  → fetch from remote → cache result → return Right(data)
/// - Offline → try cache → return Right(cached) or Left(NetworkFailure)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final HomeDataModel model = await remoteDataSource.getHomeData();
        // Persist in cache for offline use.
        await localDataSource.cacheHomeData(model);
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
      // Offline path — serve from cache.
      try {
        final HomeDataModel cached = await localDataSource.getCachedHomeData();
        return Right(cached);
      } on CacheException {
        return const Left(NetworkFailure());
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }
}
