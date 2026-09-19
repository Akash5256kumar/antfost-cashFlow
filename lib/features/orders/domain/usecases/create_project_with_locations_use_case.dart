import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/services/project_location_api_service.dart';

class CreateProjectWithLocationsUseCase implements UseCase<CreatedProject, CreateProjectWithLocationsParams> {
  final ProjectLocationApiService _apiService;

  const CreateProjectWithLocationsUseCase(this._apiService);

  @override
  Future<Either<Failure, CreatedProject>> call(CreateProjectWithLocationsParams params) async {
    try {
      final createdProject = await _apiService.createProject(
        name: params.name,
        projectType: params.projectType,
        locations: params.locations,
      );
      return Right(createdProject);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class CreateProjectWithLocationsParams extends Equatable {
  final String name;
  final String projectType;
  final List<ProjectLocationPayload> locations;

  const CreateProjectWithLocationsParams({
    required this.name,
    required this.projectType,
    required this.locations,
  });

  @override
  List<Object?> get props => [name, projectType, locations];
}
