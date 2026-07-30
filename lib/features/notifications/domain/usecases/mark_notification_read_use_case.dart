import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

/// Parameters required to mark a single notification as read.
class MarkReadParams extends Equatable {
  final String notificationId;

  const MarkReadParams(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Marks a single notification as read.
class MarkNotificationReadUseCase implements UseCase<bool, MarkReadParams> {
  final NotificationsRepository repository;

  const MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(MarkReadParams params) {
    return repository.markAsRead(params.notificationId);
  }
}
