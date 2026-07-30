import 'package:equatable/equatable.dart';

/// Base class for all notifications BLoC events.
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

/// Triggers an initial or refresh load of notifications.
final class FetchNotificationsEvent extends NotificationsEvent {
  const FetchNotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Marks the notification with [id] as read, then refreshes the list.
final class MarkNotificationReadEvent extends NotificationsEvent {
  final String id;

  const MarkNotificationReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Marks all notifications as read, then refreshes the list.
final class MarkAllReadEvent extends NotificationsEvent {
  const MarkAllReadEvent();

  @override
  List<Object?> get props => [];
}

/// Retries a previously failed notifications operation.
final class RetryNotificationsEvent extends NotificationsEvent {
  const RetryNotificationsEvent();

  @override
  List<Object?> get props => [];
}
