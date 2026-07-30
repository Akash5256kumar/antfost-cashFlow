import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

/// Verifies the current status of an existing payment.
class VerifyPaymentUseCase extends UseCase<Payment, VerifyPaymentParams> {
  final PaymentRepository repository;

  const VerifyPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, Payment>> call(VerifyPaymentParams params) {
    if (params.paymentId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Payment ID is required.')),
      );
    }
    return repository.verifyPayment(params.paymentId.trim());
  }
}

/// Parameters for [VerifyPaymentUseCase].
class VerifyPaymentParams extends Equatable {
  final String paymentId;

  const VerifyPaymentParams({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}
