import 'package:equatable/equatable.dart';

import '../../../../core/services/project_location_api_service.dart';
import '../../order_project_summary.dart';
import 'add_new_project_bloc.dart'; // To reference the bloc if needed, wait, state doesn't need bloc. I'll just import what's needed.

enum AddNewProjectStatus {
  initial,
  loadingTypes,
  typesLoaded,
  saving,
  success,
  failure,
}

class AddNewProjectState extends Equatable {
  final AddNewProjectStatus status;
  final String? errorMessage;

  final List<ProjectType> projectTypes;
  final String projectName;
  final String? selectedType;
  final List<ProjectLocationDraft> locations;

  // The final resulting project info to return back on success
  final CreatedProject? createdProject;

  const AddNewProjectState({
    this.status = AddNewProjectStatus.initial,
    this.errorMessage,
    this.projectTypes = const [],
    this.projectName = '',
    this.selectedType,
    this.locations = const [],
    this.createdProject,
  });

  bool get isLocationReady => projectName.trim().isNotEmpty && selectedType != null;

  AddNewProjectState copyWith({
    AddNewProjectStatus? status,
    String? errorMessage,
    List<ProjectType>? projectTypes,
    String? projectName,
    String? selectedType,
    List<ProjectLocationDraft>? locations,
    CreatedProject? createdProject,
  }) {
    return AddNewProjectState(
      status: status ?? this.status,
      errorMessage: errorMessage, // We reset error on copy unless explicitly provided, wait, usually we want to clear it if not provided. Let's do a nullable wrapper if we want to clear it. For simplicity, we just pass null when we clear.
      projectTypes: projectTypes ?? this.projectTypes,
      projectName: projectName ?? this.projectName,
      selectedType: selectedType ?? this.selectedType,
      locations: locations ?? this.locations,
      createdProject: createdProject ?? this.createdProject,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        projectTypes,
        projectName,
        selectedType,
        locations,
        createdProject,
      ];
}
