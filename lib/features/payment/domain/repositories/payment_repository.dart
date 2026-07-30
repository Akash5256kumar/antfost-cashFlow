import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';

/// Contract that the data layer must fulfil for payment operations.
/// All methods return [Either] so callers handle failures explicitly.
abstract class PaymentRepository {
  /// Initiates a new payment for [orderId] with the specified [amount] and [method].
  /// Returns a [Payment] reflecting the current state of the transaction.
  Future<Either<Failure, Payment>> initiatePayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  });

  /// Verifies the status of an existing payment identified by [paymentId].
  /// Returns the updated [Payment] entity.
  Future<Either<Failure, Payment>> verifyPayment(String paymentId);
}
