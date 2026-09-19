import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/services/project_location_api_service.dart';

class GetProjectTypesUseCase implements UseCase<List<ProjectType>, GetProjectTypesParams> {
  final ProjectLocationApiService _apiService;

  const GetProjectTypesUseCase(this._apiService);

  @override
  Future<Either<Failure, List<ProjectType>>> call(GetProjectTypesParams params) async {
    try {
      final types = await _apiService.getProjectTypes(forceRefresh: params.forceRefresh);
      return Right(types);
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

class GetProjectTypesParams extends Equatable {
  final bool forceRefresh;

  const GetProjectTypesParams({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}
