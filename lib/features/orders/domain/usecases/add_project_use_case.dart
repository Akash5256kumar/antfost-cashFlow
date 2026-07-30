import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project.dart';
import '../repositories/orders_repository.dart';

/// Use case: persist a new project after validating that the name is not empty.
class AddProjectUseCase implements UseCase<Project, AddProjectParams> {
  final OrdersRepository _repository;

  const AddProjectUseCase(this._repository);

  @override
  Future<Either<Failure, Project>> call(AddProjectParams params) {
    // Validate: project name must not be blank.
    if (params.project.name.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Project name must not be empty.')),
      );
    }
    return _repository.addProject(params.project);
  }
}

/// Parameters required by [AddProjectUseCase].
class AddProjectParams extends Equatable {
  final Project project;

  const AddProjectParams({required this.project});

  @override
  List<Object?> get props => [project];
}
