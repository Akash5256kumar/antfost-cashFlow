import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

/// Use case: retrieve the full list of orders for the current user.
class GetOrdersUseCase implements UseCase<List<Order>, NoParams> {
  final OrdersRepository _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) {
    return _repository.getOrders();
  }
}
