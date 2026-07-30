import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/mark_all_read_use_case.dart';
import '../../domain/usecases/mark_notification_read_use_case.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

/// BLoC that manages the notification centre state.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllReadUseCase markAllReadUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllReadUseCase,
  }) : super(const NotificationsInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
    on<MarkAllReadEvent>(_onMarkAllRead);
    on<RetryNotificationsEvent>(_onRetryNotifications);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Computes the number of unread notifications.
  int _countUnread(List<AppNotification> list) =>
      list.where((n) => !n.isRead).length;

  /// Loads notifications and emits [NotificationsSuccess] or
  /// [NotificationsError]. Does NOT emit [NotificationsLoading] on its own
  /// so callers can decide whether to show a spinner.
  Future<void> _loadAndEmit(Emitter<NotificationsState> emit) async {
    final result = await getNotificationsUseCase(const NoParams());
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) => emit(
        NotificationsSuccess(
          notifications: notifications,
          unreadCount: _countUnread(notifications),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  /// Handles [FetchNotificationsEvent]: loads notifications from the
  /// repository and emits the result.
  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    await _loadAndEmit(emit);
  }

  /// Handles [MarkNotificationReadEvent]: marks one notification as read
  /// then re-fetches to emit the updated list.
  Future<void> _onMarkNotificationRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final markResult = await markNotificationReadUseCase(
      MarkReadParams(event.id),
    );

    markResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) async => await _loadAndEmit(emit),
    );
  }

  /// Handles [MarkAllReadEvent]: marks all notifications as read then
  /// re-fetches to emit the updated list.
  Future<void> _onMarkAllRead(
    MarkAllReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final markResult = await markAllReadUseCase(const NoParams());

    markResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) async => await _loadAndEmit(emit),
    );
  }

  /// Handles [RetryNotificationsEvent] by re-running the fetch logic.
  Future<void> _onRetryNotifications(
    RetryNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await _onFetchNotifications(const FetchNotificationsEvent(), emit);
  }
}
