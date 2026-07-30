import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification.dart';
import '../repositories/notifications_repository.dart';

/// Fetches all notifications for the current user.
class GetNotificationsUseCase
    implements UseCase<List<AppNotification>, NoParams> {
  final NotificationsRepository repository;

  const GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppNotification>>> call(NoParams params) {
    return repository.getNotifications();
  }
}
