import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_data_source.dart';
import '../datasources/payment_remote_data_source.dart';

/// Concrete implementation of [PaymentRepository].
/// Follows the network-first strategy; caches results locally.
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final PaymentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // -------------------------------------------------------------------------
  // initiatePayment
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, Payment>> initiatePayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Cannot initiate payment while offline.'),
      );
    }
    try {
      final model = await remoteDataSource.initiatePayment(
        orderId: orderId,
        amount: amount,
        method: method,
      );
      // Cache the result so verification can fall back to it if needed.
      await localDataSource.cachePayment(model);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  // -------------------------------------------------------------------------
  // verifyPayment
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, Payment>> verifyPayment(String paymentId) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.verifyPayment(paymentId);
        await localDataSource.cachePayment(model);
        return Right(model);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      // Offline: return cached payment if available.
      try {
        final cached = await localDataSource.getCachedPayment(paymentId);
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }
}
