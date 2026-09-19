import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/mix_code.dart';
import '../../domain/entities/new_cash_order_request.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_data_source.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/project_model.dart';

/// Concrete implementation of [OrdersRepository].
///
/// Strategy:
/// - When online: attempt the remote data source, cache the result on success,
///   and map known exceptions to [Failure] subtypes.
/// - When offline: serve the local cache when available, otherwise return
///   [NetworkFailure].
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;
  final OrdersLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const OrdersRepositoryImpl({
    required OrdersRemoteDataSource remoteDataSource,
    required OrdersLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Maps a caught [Exception] to the appropriate [Failure] subtype.
  Failure _mapExceptionToFailure(Object exception) {
    if (exception is NetworkException) return NetworkFailure(exception.message);
    if (exception is ServerException) return ServerFailure(exception.message);
    if (exception is CacheException) return CacheFailure(exception.message);
    if (exception is AuthException) return AuthFailure(exception.message);
    if (exception is TimeoutException) return TimeoutFailure(exception.message);
    return const UnexpectedFailure();
  }

  // ── OrdersRepository ─────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteOrders = await _remoteDataSource.getOrders();
        // Update local cache with the freshly fetched data.
        await _localDataSource.cacheOrders(remoteOrders);
        return Right(remoteOrders);
      } catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    } else {
      // Offline path: serve from cache.
      try {
        final cachedOrders = await _localDataSource.getCachedOrders();
        return Right(cachedOrders);
      } catch (e) {
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetails(String orderId) async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final order = await _remoteDataSource.getOrderDetails(orderId);
        return Right(order);
      } catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    } else {
      // Try to find the order in the local cache.
      try {
        final cachedOrders = await _localDataSource.getCachedOrders();
        final cached = cachedOrders.where((o) => o.orderId == orderId).toList();
        if (cached.isNotEmpty) return Right(cached.first);
        return const Left(NetworkFailure());
      } catch (e) {
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<MixCode>>> getMixCodes(String projectId, String locationId) async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final mixCodes = await _remoteDataSource.getMixCodes(projectId, locationId);
        return Right(mixCodes);
      } catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTimeWindows({
    required String projectId,
    required String locationId,
    required String mixCode,
    required double quantityM3,
    required String date,
  }) async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final windows = await _remoteDataSource.getTimeWindows(
          projectId: projectId,
          locationId: locationId,
          mixCode: mixCode,
          quantityM3: quantityM3,
          date: date,
        );
        return Right(windows);
      } catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final projects = await _remoteDataSource.getProjects();
        return Right(projects);
      } catch (e) {
        return Left(_mapExceptionToFailure(e));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Project>> addProject(Project project) async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) return const Left(NetworkFailure());

    try {
      final model = ProjectModel.fromEntity(project);
      final saved = await _remoteDataSource.addProject(model);
      return Right(saved);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Order>> createCashOrder(
      NewCashOrderRequest request) async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) return const Left(NetworkFailure());

    try {
      final order = await _remoteDataSource.createCashOrder(request);
      // Invalidate cache so the new order appears on the next fetch.
      await _localDataSource.clearCache();
      return Right(order);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
