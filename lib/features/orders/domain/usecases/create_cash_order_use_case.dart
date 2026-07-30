import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/new_cash_order_request.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

/// Use case: submit a new cash order after validating business rules.
class CreateCashOrderUseCase
    implements UseCase<Order, CreateCashOrderParams> {
  final OrdersRepository _repository;

  const CreateCashOrderUseCase(this._repository);

  @override
  Future<Either<Failure, Order>> call(CreateCashOrderParams params) {
    // Validate: quantity must be greater than zero.
    if (params.request.quantity <= 0) {
      return Future.value(
        const Left(ValidationFailure('Quantity must be greater than 0.')),
      );
    }
    return _repository.createCashOrder(params.request);
  }
}

/// Parameters required by [CreateCashOrderUseCase].
class CreateCashOrderParams extends Equatable {
  final NewCashOrderRequest request;

  const CreateCashOrderParams({required this.request});

  @override
  List<Object?> get props => [request];
}
