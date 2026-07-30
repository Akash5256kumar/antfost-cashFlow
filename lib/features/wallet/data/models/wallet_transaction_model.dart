import '../../domain/entities/transaction.dart';

// ---------------------------------------------------------------------------
// Enum serialisation helpers
// ---------------------------------------------------------------------------

/// Converts a [TransactionType] to its JSON string representation.
String _transactionTypeToJson(TransactionType type) {
  switch (type) {
    case TransactionType.deposit:
      return 'deposit';
    case TransactionType.orderPayment:
      return 'orderPayment';
    case TransactionType.reserved:
      return 'reserved';
    case TransactionType.refund:
      return 'refund';
  }
}

/// Converts a JSON string to a [TransactionType].
TransactionType _transactionTypeFromJson(String value) {
  switch (value) {
    case 'orderPayment':
      return TransactionType.orderPayment;
    case 'reserved':
      return TransactionType.reserved;
    case 'refund':
      return TransactionType.refund;
    case 'deposit':
    default:
      return TransactionType.deposit;
  }
}

/// Converts a [TransactionStatus] to its JSON string representation.
String _transactionStatusToJson(TransactionStatus status) {
  switch (status) {
    case TransactionStatus.completed:
      return 'completed';
    case TransactionStatus.pending:
      return 'pending';
    case TransactionStatus.reserved:
      return 'reserved';
    case TransactionStatus.failed:
      return 'failed';
  }
}

/// Converts a JSON string to a [TransactionStatus].
TransactionStatus _transactionStatusFromJson(String value) {
  switch (value) {
    case 'pending':
      return TransactionStatus.pending;
    case 'reserved':
      return TransactionStatus.reserved;
    case 'failed':
      return TransactionStatus.failed;
    case 'completed':
    default:
      return TransactionStatus.completed;
  }
}

// ---------------------------------------------------------------------------
// WalletTransactionModel
// ---------------------------------------------------------------------------

/// Data-layer representation of [WalletTransaction].
/// Handles JSON serialisation / deserialisation.
class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.type,
    required super.name,
    super.subtitle,
    required super.amount,
    required super.isCredit,
    required super.status,
    required super.date,
  });

  /// Deserialises a [WalletTransactionModel] from a JSON map.
  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String? ?? '',
      type: _transactionTypeFromJson(json['type'] as String? ?? 'deposit'),
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isCredit: json['is_credit'] as bool? ?? true,
      status: _transactionStatusFromJson(
          json['status'] as String? ?? 'completed'),
      date: json['date'] as String? ?? '',
    );
  }

  /// Promotes a domain [WalletTransaction] entity to [WalletTransactionModel].
  factory WalletTransactionModel.fromEntity(WalletTransaction tx) {
    return WalletTransactionModel(
      id: tx.id,
      type: tx.type,
      name: tx.name,
      subtitle: tx.subtitle,
      amount: tx.amount,
      isCredit: tx.isCredit,
      status: tx.status,
      date: tx.date,
    );
  }

  /// Serialises this model to a JSON map suitable for caching.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': _transactionTypeToJson(type),
      'name': name,
      'subtitle': subtitle,
      'amount': amount,
      'is_credit': isCredit,
      'status': _transactionStatusToJson(status),
      'date': date,
    };
  }
}
