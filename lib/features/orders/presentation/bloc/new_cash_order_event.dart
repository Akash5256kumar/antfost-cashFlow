import 'package:equatable/equatable.dart';

import '../../domain/entities/mix_code.dart';

/// Sealed base class for all events handled by [NewCashOrderBloc].
sealed class NewCashOrderEvent extends Equatable {
  const NewCashOrderEvent();
}

/// Triggers loading of mix codes and projects needed for the order form.
final class LoadNewCashOrderDataEvent extends NewCashOrderEvent {
  const LoadNewCashOrderDataEvent();

  @override
  List<Object?> get props => [];
}

/// User selected a concrete mix code.
final class SelectMixCodeEvent extends NewCashOrderEvent {
  final MixCode mixCode;

  const SelectMixCodeEvent(this.mixCode);

  @override
  List<Object?> get props => [mixCode];
}

/// User entered or updated the concrete quantity (m³).
final class SetQuantityEvent extends NewCashOrderEvent {
  final double quantity;

  const SetQuantityEvent(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

/// User selected a delivery date and time slot.
final class SetScheduleEvent extends NewCashOrderEvent {
  final DateTime date;
  final String timeSlot;

  const SetScheduleEvent({required this.date, required this.timeSlot});

  @override
  List<Object?> get props => [date, timeSlot];
}

/// User selected a project by its ID.
final class SetProjectEvent extends NewCashOrderEvent {
  final String projectId;

  const SetProjectEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// User toggled the extra options on the "other" step of the order form.
final class SetExtrasEvent extends NewCashOrderEvent {
  final String? structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final bool pumpRequired;
  final bool cubeMould;
  final int numMoulds;

  const SetExtrasEvent({
    this.structureRef,
    required this.technicianRequired,
    required this.temperatureControl,
    required this.pumpRequired,
    required this.cubeMould,
    required this.numMoulds,
  });

  @override
  List<Object?> get props => [
        structureRef,
        technicianRequired,
        temperatureControl,
        pumpRequired,
        cubeMould,
        numMoulds,
      ];
}

/// User tapped "Submit" on the review screen.
final class SubmitCashOrderEvent extends NewCashOrderEvent {
  const SubmitCashOrderEvent();

  @override
  List<Object?> get props => [];
}

/// User tapped "Retry" after an error.
final class RetryNewCashOrderEvent extends NewCashOrderEvent {
  const RetryNewCashOrderEvent();

  @override
  List<Object?> get props => [];
}
