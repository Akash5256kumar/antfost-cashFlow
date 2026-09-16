import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_local_data_source.dart';
import '../datasources/invoices_remote_data_source.dart';

/// Concrete implementation of [InvoicesRepository].
/// Follows the network-first strategy with a local cache fallback.
class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesRemoteDataSource remoteDataSource;
  final InvoicesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const InvoicesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // -------------------------------------------------------------------------
  // getInvoices
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getInvoices();
        // Persist to cache for offline use.
        await localDataSource.cacheInvoices(models);
        return Right(models);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    } else {
      // Offline: try to return cached data.
      try {
        final cached = await localDataSource.getCachedInvoices();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  // -------------------------------------------------------------------------
  // getInvoiceDetail
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, InvoiceDetail>> getInvoiceDetail(
    String invoiceId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getInvoiceDetail(invoiceId);
        // Cache the detail for offline access.
        await localDataSource.cacheInvoiceDetail(model);
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
        final cached = await localDataSource.getCachedInvoiceDetail(invoiceId);
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (_) {
        return const Left(UnexpectedFailure());
      }
    }
  }

  // -------------------------------------------------------------------------
  // downloadInvoice
  // -------------------------------------------------------------------------

  @override
  Future<Either<Failure, String>> downloadInvoice(String invoiceId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.downloadInvoice(invoiceId);
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
        NetworkFailure('Cannot download invoice while offline.'),
      );
    }
  }
}
