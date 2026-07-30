import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/notification.dart';

/// Contract for the notifications feature data layer.
abstract class NotificationsRepository {
  /// Returns all notifications or a [Failure].
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  /// Marks a single notification identified by [notificationId] as read.
  ///
  /// Returns `true` on success or a [Failure].
  Future<Either<Failure, bool>> markAsRead(String notificationId);

  /// Marks every notification as read.
  ///
  /// Returns `true` on success or a [Failure].
  Future<Either<Failure, bool>> markAllAsRead();
}
