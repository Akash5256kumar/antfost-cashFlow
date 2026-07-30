import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet_balance.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_local_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

/// Concrete implementation of [WalletRepository].
/// Follows the network-first strategy with a local cache fallback.
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  final WalletLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const WalletRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // -------------------------------------------------------------------------
  // getWalletBalance
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, WalletBalance>> getWalletBalance() async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getWalletBalance();
        await localDataSource.cacheWalletBalance(model);
        return Right(model);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedWalletBalance();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  // -------------------------------------------------------------------------
  // getTransactions
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTransactions() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getTransactions();
        await localDataSource.cacheTransactions(models);
        return Right(models);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedTransactions();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  // -------------------------------------------------------------------------
  // addFunds
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> addFunds(double amount) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addFunds(amount);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      return const Left(
        NetworkFailure('Cannot add funds while offline.'),
      );
    }
  }
}
