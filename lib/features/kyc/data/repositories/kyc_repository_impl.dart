import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/kyc_document.dart';
import '../../domain/entities/kyc_status.dart';
import '../../domain/repositories/kyc_repository.dart';
import '../datasources/kyc_local_data_source.dart';
import '../datasources/kyc_remote_data_source.dart';

/// Concrete implementation of [KycRepository].
/// Delegates to [KycRemoteDataSource] when online and caches results
/// via [KycLocalDataSource].
class KycRepositoryImpl implements KycRepository {
  final KycRemoteDataSource remoteDataSource;
  final KycLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const KycRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ---------------------------------------------------------------------------
  // Get KYC status
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, KycStatus>> getKycStatus() async {
    if (!await networkInfo.isConnected) {
      // Attempt to serve stale data from the local cache when offline.
      try {
        final cached = await localDataSource.getCachedKycStatus();
        return Right(cached);
      } on CacheException {
        return const Left(NetworkFailure());
      }
    }

    try {
      final status = await remoteDataSource.getKycStatus();
      // Persist the freshly fetched status for offline access.
      await localDataSource.cacheKycStatus(status);
      return Right(status);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // ---------------------------------------------------------------------------
  // Submit KYC
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> submitKyc({
    required List<KycDocument> documents,
    required String fullName,
    required String emiratesId,
    required String tradeListNumber,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.submitKyc(
        documents: documents,
        fullName: fullName,
        emiratesId: emiratesId,
        tradeListNumber: tradeListNumber,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
