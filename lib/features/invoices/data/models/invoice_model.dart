import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';

// ---------------------------------------------------------------------------
// Enum serialisation helpers
// ---------------------------------------------------------------------------

/// Converts a [InvoiceType] to its JSON string representation.
String _invoiceTypeToJson(InvoiceType type) {
  switch (type) {
    case InvoiceType.vat:
      return 'vat';
    case InvoiceType.receipt:
      return 'receipt';
  }
}

/// Converts a JSON string to an [InvoiceType].
InvoiceType _invoiceTypeFromJson(String value) {
  switch (value) {
    case 'receipt':
      return InvoiceType.receipt;
    case 'vat':
    default:
      return InvoiceType.vat;
  }
}

/// Converts an [InvoiceStatus] to its JSON string representation.
String _invoiceStatusToJson(InvoiceStatus status) {
  switch (status) {
    case InvoiceStatus.paid:
      return 'paid';
    case InvoiceStatus.vatInvoiceReady:
      return 'vatInvoiceReady';
    case InvoiceStatus.sent:
      return 'sent';
    case InvoiceStatus.draft:
      return 'draft';
  }
}

/// Converts a JSON string to an [InvoiceStatus].
InvoiceStatus _invoiceStatusFromJson(String value) {
  switch (value) {
    case 'vatInvoiceReady':
      return InvoiceStatus.vatInvoiceReady;
    case 'sent':
      return InvoiceStatus.sent;
    case 'draft':
      return InvoiceStatus.draft;
    case 'paid':
    default:
      return InvoiceStatus.paid;
  }
}

// ---------------------------------------------------------------------------
// InvoiceLineItemModel
// ---------------------------------------------------------------------------

/// Data-layer representation of [InvoiceLineItem].
class InvoiceLineItemModel extends InvoiceLineItem {
  const InvoiceLineItemModel({
    required super.description,
    required super.quantity,
    required super.unitPrice,
    required super.total,
  });

  /// Deserialises from a JSON map.
  factory InvoiceLineItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItemModel(
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Promotes a domain [InvoiceLineItem] to [InvoiceLineItemModel].
  factory InvoiceLineItemModel.fromEntity(InvoiceLineItem item) {
    return InvoiceLineItemModel(
      description: item.description,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      total: item.total,
    );
  }

  /// Serialises to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }
}

// ---------------------------------------------------------------------------
// InvoiceModel
// ---------------------------------------------------------------------------

/// Data-layer representation of [Invoice]. Handles JSON serialisation.
class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.orderId,
    required super.totalAmount,
    required super.date,
    required super.types,
    required super.status,
  });

  /// Deserialises from a JSON map.
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final rawTypes = json['types'] as List<dynamic>? ?? [];
    return InvoiceModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
      types: rawTypes
          .map((t) => _invoiceTypeFromJson(t as String))
          .toList(),
      status: _invoiceStatusFromJson(json['status'] as String? ?? 'paid'),
    );
  }

  /// Promotes a domain [Invoice] entity to [InvoiceModel].
  factory InvoiceModel.fromEntity(Invoice invoice) {
    return InvoiceModel(
      id: invoice.id,
      orderId: invoice.orderId,
      totalAmount: invoice.totalAmount,
      date: invoice.date,
      types: invoice.types,
      status: invoice.status,
    );
  }

  /// Serialises to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'total_amount': totalAmount,
      'date': date,
      'types': types.map(_invoiceTypeToJson).toList(),
      'status': _invoiceStatusToJson(status),
    };
  }
}

// ---------------------------------------------------------------------------
// InvoiceDetailModel
// ---------------------------------------------------------------------------

/// Data-layer representation of [InvoiceDetail]. Handles JSON serialisation.
class InvoiceDetailModel extends InvoiceDetail {
  const InvoiceDetailModel({
    required super.id,
    required super.orderId,
    required super.totalAmount,
    required super.date,
    required super.types,
    required super.status,
    required super.customerName,
    required super.customerAddress,
    required super.vatNumber,
    required super.lineItems,
  });

  /// Deserialises from a JSON map.
  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final rawTypes = json['types'] as List<dynamic>? ?? [];
    final rawLineItems = json['line_items'] as List<dynamic>? ?? [];
    return InvoiceDetailModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
      types: rawTypes
          .map((t) => _invoiceTypeFromJson(t as String))
          .toList(),
      status: _invoiceStatusFromJson(json['status'] as String? ?? 'paid'),
      customerName: json['customer_name'] as String? ?? '',
      customerAddress: json['customer_address'] as String? ?? '',
      vatNumber: json['vat_number'] as String? ?? '',
      lineItems: rawLineItems
          .map((item) => InvoiceLineItemModel.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }

  /// Promotes a domain [InvoiceDetail] entity to [InvoiceDetailModel].
  factory InvoiceDetailModel.fromEntity(InvoiceDetail detail) {
    return InvoiceDetailModel(
      id: detail.id,
      orderId: detail.orderId,
      totalAmount: detail.totalAmount,
      date: detail.date,
      types: detail.types,
      status: detail.status,
      customerName: detail.customerName,
      customerAddress: detail.customerAddress,
      vatNumber: detail.vatNumber,
      lineItems: detail.lineItems
          .map(InvoiceLineItemModel.fromEntity)
          .toList(),
    );
  }

  /// Serialises to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'total_amount': totalAmount,
      'date': date,
      'types': types.map(_invoiceTypeToJson).toList(),
      'status': _invoiceStatusToJson(status),
      'customer_name': customerName,
      'customer_address': customerAddress,
      'vat_number': vatNumber,
      'line_items': lineItems
          .map((item) => InvoiceLineItemModel.fromEntity(item).toJson())
          .toList(),
    };
  }
}
