import '../../domain/entities/payment.dart';

// ---------------------------------------------------------------------------
// Enum serialisation helpers
// ---------------------------------------------------------------------------

/// Converts a [PaymentMethod] to its JSON string representation.
String _paymentMethodToJson(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.card:
      return 'card';
    case PaymentMethod.bankTransfer:
      return 'bankTransfer';
    case PaymentMethod.wallet:
      return 'wallet';
  }
}

/// Converts a JSON string to a [PaymentMethod].
PaymentMethod _paymentMethodFromJson(String value) {
  switch (value) {
    case 'bankTransfer':
      return PaymentMethod.bankTransfer;
    case 'wallet':
      return PaymentMethod.wallet;
    case 'card':
    default:
      return PaymentMethod.card;
  }
}

/// Converts a [PaymentStatus] to its JSON string representation.
String _paymentStatusToJson(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.pending:
      return 'pending';
    case PaymentStatus.processing:
      return 'processing';
    case PaymentStatus.success:
      return 'success';
    case PaymentStatus.failed:
      return 'failed';
  }
}

/// Converts a JSON string to a [PaymentStatus].
PaymentStatus _paymentStatusFromJson(String value) {
  switch (value) {
    case 'processing':
      return PaymentStatus.processing;
    case 'success':
      return PaymentStatus.success;
    case 'failed':
      return PaymentStatus.failed;
    case 'pending':
    default:
      return PaymentStatus.pending;
  }
}

// ---------------------------------------------------------------------------
// PaymentModel
// ---------------------------------------------------------------------------

/// Data-layer representation of [Payment].
/// Handles JSON serialisation / deserialisation.
class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.amount,
    required super.method,
    required super.status,
    super.transactionId,
  });

  /// Deserialises a [PaymentModel] from a JSON map.
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: _paymentMethodFromJson(json['method'] as String? ?? 'card'),
      status: _paymentStatusFromJson(json['status'] as String? ?? 'pending'),
      transactionId: json['transaction_id'] as String?,
    );
  }

  /// Promotes a domain [Payment] entity to [PaymentModel].
  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      orderId: payment.orderId,
      amount: payment.amount,
      method: payment.method,
      status: payment.status,
      transactionId: payment.transactionId,
    );
  }

  /// Serialises this model to a JSON map suitable for caching.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'amount': amount,
      'method': _paymentMethodToJson(method),
      'status': _paymentStatusToJson(status),
      'transaction_id': transactionId,
    };
  }
}
