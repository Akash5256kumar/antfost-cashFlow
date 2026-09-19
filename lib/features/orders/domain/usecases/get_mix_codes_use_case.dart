import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mix_code.dart';
import '../repositories/orders_repository.dart';

class MixCodesParams extends Equatable {
  const MixCodesParams({required this.projectId, required this.locationId});
  final String projectId;
  final String locationId;

  @override
  List<Object> get props => [projectId, locationId];
}

/// Use case: retrieve the catalogue of available concrete mix codes.
class GetMixCodesUseCase implements UseCase<List<MixCode>, MixCodesParams> {
  final OrdersRepository _repository;

  const GetMixCodesUseCase(this._repository);

  @override
  Future<Either<Failure, List<MixCode>>> call(MixCodesParams params) {
    return _repository.getMixCodes(params.projectId, params.locationId);
  }
}
