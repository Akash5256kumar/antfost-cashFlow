import 'package:equatable/equatable.dart';

/// Value object that carries the user's input when placing a new cash order.
/// Pure Dart — no Flutter or external framework imports.
class NewCashOrderRequest extends Equatable {
  final String mixCode;
  final double quantity;
  final String projectId;
  final DateTime scheduledDate;
  final String timeSlot;
  final String? structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final bool pumpRequired;
  final bool cubeMould;
  final int numMoulds;

  const NewCashOrderRequest({
    required this.mixCode,
    required this.quantity,
    required this.projectId,
    required this.scheduledDate,
    required this.timeSlot,
    this.structureRef,
    required this.technicianRequired,
    required this.temperatureControl,
    required this.pumpRequired,
    required this.cubeMould,
    required this.numMoulds,
  });

  @override
  List<Object?> get props => [
        mixCode,
        quantity,
        projectId,
        scheduledDate,
        timeSlot,
        structureRef,
        technicianRequired,
        temperatureControl,
        pumpRequired,
        cubeMould,
        numMoulds,
      ];
}
