import 'package:equatable/equatable.dart';

/// Identifies whether an invoice carries a VAT certificate or is a simple receipt.
enum InvoiceType { vat, receipt }

/// Lifecycle status of an invoice.
enum InvoiceStatus { paid, vatInvoiceReady, sent, draft }

/// Core domain entity representing a single invoice.
/// Pure Dart — no Flutter or JSON imports.
class Invoice extends Equatable {
  final String id;
  final String orderId;
  final double totalAmount;
  final String date;
  final List<InvoiceType> types;
  final InvoiceStatus status;

  const Invoice({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.date,
    required this.types,
    required this.status,
  });

  @override
  List<Object?> get props => [id, orderId, totalAmount, date, types, status];
}
