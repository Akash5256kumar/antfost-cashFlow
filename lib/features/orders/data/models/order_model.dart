import '../../domain/entities/order.dart';

/// Data model that extends the [Order] domain entity.
/// Adds JSON serialisation and a factory to convert from the entity.
class OrderModel extends Order {
  const OrderModel({
    required super.orderId,
    required super.status,
    required super.grade,
    required super.location,
    required super.timeSlot,
    required super.volume,
    required super.date,
    required super.amount,
    super.imageUrl,
    super.paymentStatus,
    super.delivered,
    super.total,
  });

  // ── JSON de-serialisation ─────────────────────────────────────────────────

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      // Mobile API returns IDs and volume as numbers on some list endpoints.
      // Convert each display field defensively so a valid list never becomes
      // an `UnexpectedFailure` in the OrdersBloc.
      orderId: json['orderId']?.toString() ?? '',
      status: _statusFromString(json['status']?.toString() ?? ''),
      grade: json['grade']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      timeSlot: json['timeSlot']?.toString() ?? '',
      volume:
          json['volumeLabel']?.toString() ?? json['volume']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      delivered: json['delivered'] as int?,
      total: json['total'] as int?,
    );
  }

  // ── JSON serialisation ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': _statusToString(status),
      'grade': grade,
      'location': location,
      'timeSlot': timeSlot,
      'volume': volume,
      'date': date,
      'amount': amount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (delivered != null) 'delivered': delivered,
      if (total != null) 'total': total,
    };
  }

  // ── Convert from domain entity ────────────────────────────────────────────

  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      orderId: order.orderId,
      status: order.status,
      grade: order.grade,
      location: order.location,
      timeSlot: order.timeSlot,
      volume: order.volume,
      date: order.date,
      amount: order.amount,
      imageUrl: order.imageUrl,
      paymentStatus: order.paymentStatus,
      delivered: order.delivered,
      total: order.total,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static OrderStatusType _statusFromString(String value) {
    switch (value.trim().toLowerCase().replaceAll(RegExp(r'[ _-]'), '')) {
      case 'pending':
        return OrderStatusType.pending;
      case 'confirmed':
        return OrderStatusType.confirmed;
      case 'inprogress':
        return OrderStatusType.inProgress;
      case 'scheduled':
        return OrderStatusType.scheduled;
      case 'completed':
        return OrderStatusType.completed;
      case 'draft':
        return OrderStatusType.draft;
      default:
        return OrderStatusType.draft;
    }
  }

  static String _statusToString(OrderStatusType status) {
    switch (status) {
      case OrderStatusType.pending:
        return 'pending';
      case OrderStatusType.confirmed:
        return 'confirmed';
      case OrderStatusType.inProgress:
        return 'inProgress';
      case OrderStatusType.scheduled:
        return 'scheduled';
      case OrderStatusType.completed:
        return 'completed';
      case OrderStatusType.draft:
        return 'draft';
    }
  }
}
