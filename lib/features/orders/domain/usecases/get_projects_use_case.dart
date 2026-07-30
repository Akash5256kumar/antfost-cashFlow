import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project.dart';
import '../repositories/orders_repository.dart';

/// Use case: retrieve the list of projects belonging to the current user.
class GetProjectsUseCase implements UseCase<List<Project>, NoParams> {
  final OrdersRepository _repository;

  const GetProjectsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) {
    return _repository.getProjects();
  }
}
