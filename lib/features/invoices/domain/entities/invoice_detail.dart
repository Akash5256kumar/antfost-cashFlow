import 'package:equatable/equatable.dart';

import 'invoice.dart';

/// Extended invoice entity that includes customer details and a breakdown of
/// individual line items. Extends [Invoice] so it can be used wherever an
/// [Invoice] is expected.
class InvoiceDetail extends Invoice {
  final String customerName;
  final String customerAddress;
  final String vatNumber;
  final List<InvoiceLineItem> lineItems;

  const InvoiceDetail({
    required super.id,
    required super.orderId,
    required super.totalAmount,
    required super.date,
    required super.types,
    required super.status,
    required this.customerName,
    required this.customerAddress,
    required this.vatNumber,
    required this.lineItems,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        customerName,
        customerAddress,
        vatNumber,
        lineItems,
      ];
}

/// A single product/service line on an invoice.
class InvoiceLineItem extends Equatable {
  final String description;
  final double quantity;
  final double unitPrice;
  final double total;

  const InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  @override
  List<Object?> get props => [description, quantity, unitPrice, total];
}
