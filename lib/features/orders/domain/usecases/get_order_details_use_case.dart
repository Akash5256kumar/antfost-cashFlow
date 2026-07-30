import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

/// Use case: retrieve the details of a single order by its [orderId].
class GetOrderDetailsUseCase implements UseCase<Order, GetOrderDetailsParams> {
  final OrdersRepository _repository;

  const GetOrderDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, Order>> call(GetOrderDetailsParams params) {
    return _repository.getOrderDetails(params.orderId);
  }
}

/// Parameters required by [GetOrderDetailsUseCase].
class GetOrderDetailsParams extends Equatable {
  final String orderId;

  const GetOrderDetailsParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
