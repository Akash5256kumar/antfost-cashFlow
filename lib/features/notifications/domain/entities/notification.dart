import 'package:equatable/equatable.dart';

/// Categories of app notifications — mirrors the filter chips shown in the
/// notification centre (All / Operational / Financial / Risk).
enum NotificationCategory { operational, financial, risk }

/// A single notification displayed in the notification centre.
class AppNotification extends Equatable {
  final String id;
  final String title;
  final String message;

  /// Display string for when the notification happened, e.g. "1d ago" or
  /// "02 Feb" for older entries.
  final String date;

  /// Whether the user has already seen/read this notification.
  final bool isRead;

  final NotificationCategory category;

  /// Related order reference shown as a tag pill, when applicable.
  final String? orderId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    required this.category,
    this.orderId,
  });

  @override
  List<Object?> get props =>
      [id, title, message, date, isRead, category, orderId];
}
