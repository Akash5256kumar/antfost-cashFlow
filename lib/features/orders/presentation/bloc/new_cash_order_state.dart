import 'package:equatable/equatable.dart';

import '../../domain/entities/mix_code.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/project.dart';

/// Sealed base class for all states emitted by [NewCashOrderBloc].
sealed class NewCashOrderState extends Equatable {
  const NewCashOrderState();
}

/// Initial state before [LoadNewCashOrderDataEvent] has been dispatched.
final class NewCashOrderInitial extends NewCashOrderState {
  const NewCashOrderInitial();

  @override
  List<Object?> get props => [];
}

/// Emitted while reference data (mix codes, projects) is loading.
final class NewCashOrderLoading extends NewCashOrderState {
  const NewCashOrderLoading();

  @override
  List<Object?> get props => [];
}

/// Emitted once reference data is loaded and whenever any form field changes.
///
/// All form fields are carried in this state so the UI can rebuild
/// incrementally without losing unsaved input.
final class NewCashOrderDataLoaded extends NewCashOrderState {
  final List<MixCode> mixCodes;
  final List<Project> projects;
  final MixCode? selectedMixCode;
  final double quantity;
  final DateTime? scheduledDate;
  final String? timeSlot;
  final String? projectId;
  final String? structureRef;
  final bool technicianRequired;
  final bool temperatureControl;
  final bool pumpRequired;
  final bool cubeMould;
  final int numMoulds;

  const NewCashOrderDataLoaded({
    required this.mixCodes,
    required this.projects,
    this.selectedMixCode,
    this.quantity = 0,
    this.scheduledDate,
    this.timeSlot,
    this.projectId,
    this.structureRef,
    this.technicianRequired = false,
    this.temperatureControl = false,
    this.pumpRequired = false,
    this.cubeMould = false,
    this.numMoulds = 0,
  });

  /// Returns a copy of this state with the specified fields replaced.
  NewCashOrderDataLoaded copyWith({
    List<MixCode>? mixCodes,
    List<Project>? projects,
    MixCode? selectedMixCode,
    double? quantity,
    DateTime? scheduledDate,
    String? timeSlot,
    String? projectId,
    String? structureRef,
    bool? technicianRequired,
    bool? temperatureControl,
    bool? pumpRequired,
    bool? cubeMould,
    int? numMoulds,
  }) {
    return NewCashOrderDataLoaded(
      mixCodes: mixCodes ?? this.mixCodes,
      projects: projects ?? this.projects,
      selectedMixCode: selectedMixCode ?? this.selectedMixCode,
      quantity: quantity ?? this.quantity,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      projectId: projectId ?? this.projectId,
      structureRef: structureRef ?? this.structureRef,
      technicianRequired: technicianRequired ?? this.technicianRequired,
      temperatureControl: temperatureControl ?? this.temperatureControl,
      pumpRequired: pumpRequired ?? this.pumpRequired,
      cubeMould: cubeMould ?? this.cubeMould,
      numMoulds: numMoulds ?? this.numMoulds,
    );
  }

  @override
  List<Object?> get props => [
        mixCodes,
        projects,
        selectedMixCode,
        quantity,
        scheduledDate,
        timeSlot,
        projectId,
        structureRef,
        technicianRequired,
        temperatureControl,
        pumpRequired,
        cubeMould,
        numMoulds,
      ];
}

/// Emitted while the order submission request is in-flight.
final class NewCashOrderSubmitting extends NewCashOrderState {
  const NewCashOrderSubmitting();

  @override
  List<Object?> get props => [];
}

/// Emitted when the order has been successfully created.
final class NewCashOrderSubmitted extends NewCashOrderState {
  final Order createdOrder;

  const NewCashOrderSubmitted(this.createdOrder);

  @override
  List<Object?> get props => [createdOrder];
}

/// Emitted when any operation fails.
final class NewCashOrderError extends NewCashOrderState {
  final String message;

  const NewCashOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
