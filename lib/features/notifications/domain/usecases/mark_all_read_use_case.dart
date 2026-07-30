import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

/// Marks all notifications as read.
class MarkAllReadUseCase implements UseCase<bool, NoParams> {
  final NotificationsRepository repository;

  const MarkAllReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.markAllAsRead();
  }
}
