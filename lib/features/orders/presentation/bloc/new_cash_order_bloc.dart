import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/mix_code.dart';
import '../../domain/entities/new_cash_order_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/create_cash_order_use_case.dart';
import '../../domain/usecases/get_mix_codes_use_case.dart';
import '../../domain/usecases/get_projects_use_case.dart';
import 'new_cash_order_event.dart';
import 'new_cash_order_state.dart';

/// BLoC that drives the multi-step new cash order form.
class NewCashOrderBloc extends Bloc<NewCashOrderEvent, NewCashOrderState> {
  final GetMixCodesUseCase _getMixCodesUseCase;
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateCashOrderUseCase _createCashOrderUseCase;

  NewCashOrderBloc({
    required GetMixCodesUseCase getMixCodesUseCase,
    required GetProjectsUseCase getProjectsUseCase,
    required CreateCashOrderUseCase createCashOrderUseCase,
  })  : _getMixCodesUseCase = getMixCodesUseCase,
        _getProjectsUseCase = getProjectsUseCase,
        _createCashOrderUseCase = createCashOrderUseCase,
        super(const NewCashOrderInitial()) {
    on<LoadNewCashOrderDataEvent>(_onLoadData);
    on<SelectMixCodeEvent>(_onSelectMixCode);
    on<SetQuantityEvent>(_onSetQuantity);
    on<SetScheduleEvent>(_onSetSchedule);
    on<SetProjectEvent>(_onSetProject);
    on<SetExtrasEvent>(_onSetExtras);
    on<SubmitCashOrderEvent>(_onSubmit);
    on<RetryNewCashOrderEvent>(_onRetry);
  }

  // ── Event handlers ─────────────────────────────────────────────────────

  Future<void> _onLoadData(
    LoadNewCashOrderDataEvent event,
    Emitter<NewCashOrderState> emit,
  ) async {
    emit(const NewCashOrderLoading());

    // Fetch projects. Mix codes will be fetched later when a project is selected.
    final projectsResult = await _getProjectsUseCase(const NoParams());

    if (projectsResult.isLeft()) {
      final failure = projectsResult.fold((f) => f, (_) => null)!;
      emit(NewCashOrderError(failure.message));
      return;
    }

    final projects = projectsResult.fold((_) => <Project>[], (list) => list);

    emit(
      NewCashOrderDataLoaded(
        mixCodes: const [],
        projects: projects,
      ),
    );
  }

  void _onSelectMixCode(
    SelectMixCodeEvent event,
    Emitter<NewCashOrderState> emit,
  ) {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;
    emit(current.copyWith(selectedMixCode: event.mixCode));
  }

  void _onSetQuantity(
    SetQuantityEvent event,
    Emitter<NewCashOrderState> emit,
  ) {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;
    emit(current.copyWith(quantity: event.quantity));
  }

  void _onSetSchedule(
    SetScheduleEvent event,
    Emitter<NewCashOrderState> emit,
  ) {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;
    emit(current.copyWith(
      scheduledDate: event.date,
      timeSlot: event.timeSlot,
    ));
  }

  void _onSetProject(
    SetProjectEvent event,
    Emitter<NewCashOrderState> emit,
  ) {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;
    emit(current.copyWith(projectId: event.projectId));
  }

  void _onSetExtras(
    SetExtrasEvent event,
    Emitter<NewCashOrderState> emit,
  ) {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;
    emit(current.copyWith(
      structureRef: event.structureRef,
      technicianRequired: event.technicianRequired,
      temperatureControl: event.temperatureControl,
      pumpRequired: event.pumpRequired,
      cubeMould: event.cubeMould,
      numMoulds: event.numMoulds,
    ));
  }

  Future<void> _onSubmit(
    SubmitCashOrderEvent event,
    Emitter<NewCashOrderState> emit,
  ) async {
    final current = state;
    if (current is! NewCashOrderDataLoaded) return;

    // ── Pre-submission validation ────────────────────────────────────────
    if (current.selectedMixCode == null) {
      emit(const NewCashOrderError('Please select a mix code.'));
      return;
    }
    if (current.quantity <= 0) {
      emit(const NewCashOrderError('Quantity must be greater than 0.'));
      return;
    }
    if (current.scheduledDate == null) {
      emit(const NewCashOrderError('Please select a delivery date.'));
      return;
    }

    emit(const NewCashOrderSubmitting());

    final request = NewCashOrderRequest(
      mixCode: current.selectedMixCode!.code,
      quantity: current.quantity,
      projectId: current.projectId ?? '',
      scheduledDate: current.scheduledDate!,
      timeSlot: current.timeSlot ?? '',
      structureRef: current.structureRef,
      technicianRequired: current.technicianRequired,
      temperatureControl: current.temperatureControl,
      pumpRequired: current.pumpRequired,
      cubeMould: current.cubeMould,
      numMoulds: current.numMoulds,
    );

    final result = await _createCashOrderUseCase(
      CreateCashOrderParams(request: request),
    );

    result.fold(
      (failure) => emit(NewCashOrderError(failure.message)),
      (order) => emit(NewCashOrderSubmitted(order)),
    );
  }

  Future<void> _onRetry(
    RetryNewCashOrderEvent event,
    Emitter<NewCashOrderState> emit,
  ) async {
    await _onLoadData(const LoadNewCashOrderDataEvent(), emit);
  }
}
