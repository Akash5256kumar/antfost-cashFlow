import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';

class TimeWindowsParams extends Equatable {
  const TimeWindowsParams({
    required this.projectId,
    required this.locationId,
    required this.mixCode,
    required this.quantityM3,
    required this.date,
  });

  final String projectId;
  final String locationId;
  final String mixCode;
  final double quantityM3;
  final String date;

  @override
  List<Object> get props => [projectId, locationId, mixCode, quantityM3, date];
}

class GetTimeWindowsUseCase
    implements UseCase<List<Map<String, dynamic>>, TimeWindowsParams> {
  final OrdersRepository _repository;

  const GetTimeWindowsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      TimeWindowsParams params) {
    return _repository.getTimeWindows(
      projectId: params.projectId,
      locationId: params.locationId,
      mixCode: params.mixCode,
      quantityM3: params.quantityM3,
      date: params.date,
    );
  }
}
