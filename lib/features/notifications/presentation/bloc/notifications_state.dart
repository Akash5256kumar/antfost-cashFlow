import 'package:equatable/equatable.dart';

import '../../domain/entities/notification.dart';

/// Base class for all notifications BLoC states.
sealed class NotificationsState extends Equatable {
  const NotificationsState();
}

/// The BLoC has not yet received any event.
final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();

  @override
  List<Object?> get props => [];
}

/// Notifications are being fetched or a mark-read operation is in progress.
final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();

  @override
  List<Object?> get props => [];
}

/// Notifications were loaded successfully.
final class NotificationsSuccess extends NotificationsState {
  final List<AppNotification> notifications;

  /// Pre-computed count of unread notifications for badge display.
  final int unreadCount;

  const NotificationsSuccess({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// A notifications operation failed.
final class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
