import 'package:equatable/equatable.dart';

/// Represents the current lifecycle state of an order.
enum OrderStatusType { inProgress, scheduled, completed }

/// Domain entity representing a concrete delivery order.
/// Pure Dart — no Flutter or external framework imports.
class Order extends Equatable {
  final String orderId;
  final OrderStatusType status;
  final String grade;
  final String location;
  final String timeSlot;
  final String volume;
  final String date;
  final double amount;

  /// Number of m³ already delivered (only relevant for inProgress orders).
  final int? delivered;

  /// Total number of m³ ordered (only relevant for inProgress orders).
  final int? total;

  const Order({
    required this.orderId,
    required this.status,
    required this.grade,
    required this.location,
    required this.timeSlot,
    required this.volume,
    required this.date,
    required this.amount,
    this.delivered,
    this.total,
  });

  @override
  List<Object?> get props => [
        orderId,
        status,
        grade,
        location,
        timeSlot,
        volume,
        date,
        amount,
        delivered,
        total,
      ];
}
