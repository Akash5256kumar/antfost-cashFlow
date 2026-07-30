import '../../../../core/errors/exceptions.dart';
import '../models/notification_model.dart';

/// Contract for the notifications local data source (cache).
abstract class NotificationsLocalDataSource {
  /// Returns the cached list of notifications.
  ///
  /// Throws [CacheException] when no cached data is available.
  Future<List<AppNotificationModel>> getCachedNotifications();

  /// Replaces the cached list with [notifications].
  Future<void> cacheNotifications(List<AppNotificationModel> notifications);

  /// Updates the cached notification identified by [notificationId] to
  /// [isRead] = `true`.
  ///
  /// Throws [CacheException] when no cache exists or the id is not found.
  Future<void> markAsRead(String notificationId);

  /// Updates every cached notification so that [isRead] = `true`.
  ///
  /// Throws [CacheException] when no cache exists.
  Future<void> markAllAsRead();
}

/// In-memory mock implementation. Data lives only for the app session.
class MockNotificationsLocalDataSource implements NotificationsLocalDataSource {
  List<AppNotificationModel>? _cache;

  @override
  Future<List<AppNotificationModel>> getCachedNotifications() async {
    if (_cache == null) {
      throw const CacheException('No cached notifications available.');
    }
    return List.unmodifiable(_cache!);
  }

  @override
  Future<void> cacheNotifications(
    List<AppNotificationModel> notifications,
  ) async {
    _cache = List.of(notifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    if (_cache == null) {
      throw const CacheException('No cached notifications to update.');
    }
    final index = _cache!.indexWhere((n) => n.id == notificationId);
    if (index == -1) {
      throw CacheException('Notification $notificationId not found in cache.');
    }
    _cache![index] = _cache![index].copyWithRead();
  }

  @override
  Future<void> markAllAsRead() async {
    if (_cache == null) {
      throw const CacheException('No cached notifications to update.');
    }
    _cache = _cache!.map((n) => n.copyWithRead()).toList();
  }
}
