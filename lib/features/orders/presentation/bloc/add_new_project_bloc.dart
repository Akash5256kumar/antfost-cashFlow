import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/project_location_api_service.dart';
import '../../domain/usecases/create_project_with_locations_use_case.dart';
import '../../domain/usecases/get_project_types_use_case.dart';
import '../../order_project_summary.dart';
import 'add_new_project_event.dart';
import 'add_new_project_state.dart';

class AddNewProjectBloc extends Bloc<AddNewProjectEvent, AddNewProjectState> {
  final GetProjectTypesUseCase _getProjectTypesUseCase;
  final CreateProjectWithLocationsUseCase _createProjectWithLocationsUseCase;
  final ProjectLocationApiService _apiService; // To access cache synchronously

  AddNewProjectBloc({
    required GetProjectTypesUseCase getProjectTypesUseCase,
    required CreateProjectWithLocationsUseCase createProjectWithLocationsUseCase,
    required ProjectLocationApiService apiService,
  })  : _getProjectTypesUseCase = getProjectTypesUseCase,
        _createProjectWithLocationsUseCase = createProjectWithLocationsUseCase,
        _apiService = apiService,
        super(const AddNewProjectState()) {
    on<LoadProjectTypesEvent>(_onLoadProjectTypes);
    on<ProjectNameChangedEvent>(_onProjectNameChanged);
    on<ProjectTypeChangedEvent>(_onProjectTypeChanged);
    on<LocationAddedEvent>(_onLocationAdded);
    on<SubmitProjectEvent>(_onSubmitProject);
  }

  Future<void> _onLoadProjectTypes(
      LoadProjectTypesEvent event, Emitter<AddNewProjectState> emit) async {
    // If we're not force-refreshing and we have cached types, emit them immediately
    if (!event.forceRefresh && _apiService.cachedProjectTypes != null) {
      emit(state.copyWith(
        projectTypes: _apiService.cachedProjectTypes!,
        status: AddNewProjectStatus.typesLoaded,
      ));
      // Trigger a silent background refresh
      add(const LoadProjectTypesEvent(forceRefresh: true));
      return;
    }

    if (state.projectTypes.isEmpty) {
      emit(state.copyWith(status: AddNewProjectStatus.loadingTypes));
    }

    final result = await _getProjectTypesUseCase(
        GetProjectTypesParams(forceRefresh: event.forceRefresh));

    result.fold(
      (failure) {
        if (!event.forceRefresh) {
          emit(state.copyWith(
            status: AddNewProjectStatus.failure,
            errorMessage: failure.message,
          ));
        }
      },
      (types) {
        // Validate if selected type is still in the list
        String? newSelectedType = state.selectedType;
        if (newSelectedType != null && !types.any((t) => t.value == newSelectedType)) {
          newSelectedType = null;
        }

        emit(state.copyWith(
          projectTypes: types,
          selectedType: newSelectedType,
          status: AddNewProjectStatus.typesLoaded,
        ));
      },
    );
  }

  void _onProjectNameChanged(
      ProjectNameChangedEvent event, Emitter<AddNewProjectState> emit) {
    emit(state.copyWith(projectName: event.name));
  }

  void _onProjectTypeChanged(
      ProjectTypeChangedEvent event, Emitter<AddNewProjectState> emit) {
    emit(state.copyWith(selectedType: event.selectedType));
  }

  void _onLocationAdded(
      LocationAddedEvent event, Emitter<AddNewProjectState> emit) {
    final updatedLocations = [...state.locations, event.location];
    emit(state.copyWith(locations: updatedLocations));
  }

  Future<void> _onSubmitProject(
      SubmitProjectEvent event, Emitter<AddNewProjectState> emit) async {
    if (state.selectedType == null) {
      emit(state.copyWith(
        status: AddNewProjectStatus.failure,
        errorMessage: 'Select a project type to continue.',
      ));
      return;
    }

    final submitLocations = [...state.locations];
    if (event.location != null) {
      submitLocations.add(event.location!);
    }

    if (submitLocations.isEmpty) {
      emit(state.copyWith(
        status: AddNewProjectStatus.failure,
        errorMessage: 'Add at least one delivery location to continue.',
      ));
      return;
    }

    emit(state.copyWith(status: AddNewProjectStatus.saving));

    final payloads = submitLocations.map((item) => ProjectLocationPayload(
          name: item.name,
          address: item.address,
          latitude: item.latitude,
          longitude: item.longitude,
          contactName: item.contactName ?? '',
          contactPhone: item.contactPhone ?? '',
        )).toList();

    final result = await _createProjectWithLocationsUseCase(
        CreateProjectWithLocationsParams(
      name: state.projectName.trim(),
      projectType: state.selectedType!,
      locations: payloads,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AddNewProjectStatus.failure,
        errorMessage: failure.message,
      )),
      (created) => emit(state.copyWith(
        status: AddNewProjectStatus.success,
        createdProject: created,
      )),
    );
  }
}
