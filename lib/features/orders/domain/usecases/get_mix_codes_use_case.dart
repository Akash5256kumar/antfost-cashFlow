import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mix_code.dart';
import '../repositories/orders_repository.dart';

/// Use case: retrieve the catalogue of available concrete mix codes.
class GetMixCodesUseCase implements UseCase<List<MixCode>, NoParams> {
  final OrdersRepository _repository;

  const GetMixCodesUseCase(this._repository);

  @override
  Future<Either<Failure, List<MixCode>>> call(NoParams params) {
    return _repository.getMixCodes();
  }
}
