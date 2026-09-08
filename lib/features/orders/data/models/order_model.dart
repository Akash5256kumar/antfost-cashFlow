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
    super.delivered,
    super.total,
  });

  // ── JSON de-serialisation ─────────────────────────────────────────────────

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String,
      status: _statusFromString(json['status'] as String),
      grade: json['grade'] as String,
      location: json['location'] as String,
      timeSlot: json['timeSlot'] as String,
      volume: json['volume'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
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
      delivered: order.delivered,
      total: order.total,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static OrderStatusType _statusFromString(String value) {
    switch (value) {
      case 'inProgress':
        return OrderStatusType.inProgress;
      case 'scheduled':
        return OrderStatusType.scheduled;
      case 'completed':
        return OrderStatusType.completed;
      case 'draft':
        return OrderStatusType.draft;
      default:
        return OrderStatusType.scheduled;
    }
  }

  static String _statusToString(OrderStatusType status) {
    switch (status) {
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
