import 'package:equatable/equatable.dart';

import '../../domain/entities/payment.dart';

/// Base class for all payment events.
sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers the payment initiation flow.
class InitiatePaymentEvent extends PaymentEvent {
  final String orderId;
  final double amount;
  final PaymentMethod method;

  const InitiatePaymentEvent({
    required this.orderId,
    required this.amount,
    required this.method,
  });

  @override
  List<Object?> get props => [orderId, amount, method];
}

/// Triggers a verification check for an existing payment.
class VerifyPaymentEvent extends PaymentEvent {
  final String paymentId;

  const VerifyPaymentEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

/// Resets the BLoC back to [PaymentInitial] so the user can retry.
class RetryPaymentEvent extends PaymentEvent {
  const RetryPaymentEvent();
}
