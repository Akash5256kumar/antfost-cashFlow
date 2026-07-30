import 'package:equatable/equatable.dart';

/// The nature of a wallet movement.
enum TransactionType { deposit, orderPayment, reserved, refund }

/// Lifecycle status of a wallet transaction.
enum TransactionStatus { completed, pending, reserved, failed }

/// Domain entity representing a single wallet transaction.
/// Pure Dart — no Flutter or JSON imports.
class WalletTransaction extends Equatable {
  final String id;
  final TransactionType type;
  final String name;
  final String? subtitle;

  /// Absolute amount of the transaction (always positive).
  final double amount;

  /// `true` when the transaction adds funds (credit), `false` when it deducts.
  final bool isCredit;

  final TransactionStatus status;
  final String date;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.name,
    this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props =>
      [id, type, name, subtitle, amount, isCredit, status, date];
}
