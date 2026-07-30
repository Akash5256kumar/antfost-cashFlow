import 'package:equatable/equatable.dart';

/// The payment instrument used for a transaction.
enum PaymentMethod { card, bankTransfer, wallet }

/// Lifecycle status of a payment.
enum PaymentStatus { pending, processing, success, failed }

/// Core domain entity representing a payment transaction.
/// Pure Dart — no Flutter or JSON imports.
class Payment extends Equatable {
  final String id;
  final String orderId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;

  /// The gateway transaction reference, available once the payment is processed.
  final String? transactionId;

  const Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
  });

  @override
  List<Object?> get props =>
      [id, orderId, amount, method, status, transactionId];
}
