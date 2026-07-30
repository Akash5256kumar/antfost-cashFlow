import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

/// Initiates a new payment after validating the provided parameters.
class InitiatePaymentUseCase extends UseCase<Payment, InitiatePaymentParams> {
  final PaymentRepository repository;

  const InitiatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, Payment>> call(InitiatePaymentParams params) {
    if (params.orderId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Order ID is required.')),
      );
    }
    if (params.amount <= 0) {
      return Future.value(
        const Left(ValidationFailure('Amount must be greater than zero.')),
      );
    }
    return repository.initiatePayment(
      orderId: params.orderId.trim(),
      amount: params.amount,
      method: params.method,
    );
  }
}

/// Parameters for [InitiatePaymentUseCase].
class InitiatePaymentParams extends Equatable {
  final String orderId;
  final double amount;
  final PaymentMethod method;

  const InitiatePaymentParams({
    required this.orderId,
    required this.amount,
    required this.method,
  });

  @override
  List<Object?> get props => [orderId, amount, method];
}
