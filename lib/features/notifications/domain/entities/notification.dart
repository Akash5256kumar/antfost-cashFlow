import 'package:equatable/equatable.dart';

/// Categories of app notifications.
enum NotificationType { order, payment, system, kyc }

/// A single notification displayed in the notification centre.
class AppNotification extends Equatable {
  final String id;
  final String title;
  final String message;
  final String date;

  /// Whether the user has already seen/read this notification.
  final bool isRead;

  final NotificationType type;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, message, date, isRead, type];
}
