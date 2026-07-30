import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

/// Fetches aggregated home screen data.
///
/// Accepts [NoParams] because no input is required.
class GetHomeDataUseCase implements UseCase<HomeData, NoParams> {
  final HomeRepository repository;

  const GetHomeDataUseCase(this.repository);

  @override
  Future<Either<Failure, HomeData>> call(NoParams params) {
    return repository.getHomeData();
  }
}
