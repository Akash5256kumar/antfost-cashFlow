import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failures.dart';
import '../entities/mix_code.dart';
import '../entities/new_cash_order_request.dart';
import '../entities/order.dart';
import '../entities/project.dart';

/// Contract for all order-related data operations.
/// Implementations live in the data layer.
abstract class OrdersRepository {
  /// Fetches the authenticated user's full order list.
  Future<Either<Failure, List<Order>>> getOrders();

  /// Fetches the detail of a single order by [orderId].
  Future<Either<Failure, Order>> getOrderDetails(String orderId);

  /// Returns the catalogue of available concrete mix codes.
  Future<Either<Failure, List<MixCode>>> getMixCodes();

  /// Returns the list of projects belonging to the authenticated user.
  Future<Either<Failure, List<Project>>> getProjects();

  /// Persists a new [project] and returns the saved entity (with server-assigned id).
  Future<Either<Failure, Project>> addProject(Project project);

  /// Submits a new cash order described by [request] and returns the created order.
  Future<Either<Failure, Order>> createCashOrder(NewCashOrderRequest request);
}
