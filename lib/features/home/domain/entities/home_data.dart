import 'package:equatable/equatable.dart';

/// Represents a single active concrete order shown on the home screen.
class ActiveOrder extends Equatable {
  final String orderId;

  /// Status value: 'inProgress' or 'scheduled'
  final String status;

  final String grade;
  final String location;
  final String timeSlot;
  final String volume;
  final String date;
  final double amount;

  /// Number of m³ already delivered — null when order is not yet in progress.
  final int? delivered;

  /// Total m³ for the order — null when not applicable.
  final int? total;

  const ActiveOrder({
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

/// Aggregated data displayed on the home screen.
class HomeData extends Equatable {
  final String userName;
  final String companyName;
  final List<ActiveOrder> activeOrders;
  final int projectCount;

  const HomeData({
    required this.userName,
    required this.companyName,
    required this.activeOrders,
    this.projectCount = 0,
  });

  @override
  List<Object?> get props => [
    userName,
    companyName,
    activeOrders,
    projectCount,
  ];
}
