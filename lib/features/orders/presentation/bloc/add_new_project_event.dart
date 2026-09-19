import 'package:equatable/equatable.dart';

import '../../../../core/services/project_location_api_service.dart';
import '../../order_project_summary.dart';

abstract class AddNewProjectEvent extends Equatable {
  const AddNewProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjectTypesEvent extends AddNewProjectEvent {
  final bool forceRefresh;
  const LoadProjectTypesEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ProjectNameChangedEvent extends AddNewProjectEvent {
  final String name;
  const ProjectNameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class ProjectTypeChangedEvent extends AddNewProjectEvent {
  final String selectedType;
  const ProjectTypeChangedEvent(this.selectedType);

  @override
  List<Object?> get props => [selectedType];
}

class LocationAddedEvent extends AddNewProjectEvent {
  final ProjectLocationDraft location;
  const LocationAddedEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class SubmitProjectEvent extends AddNewProjectEvent {
  final ProjectLocationDraft? location;
  const SubmitProjectEvent([this.location]);

  @override
  List<Object?> get props => [location];
}
