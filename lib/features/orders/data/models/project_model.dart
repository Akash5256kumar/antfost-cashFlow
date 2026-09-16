import '../../domain/entities/project.dart';

/// Data model that extends the [Project] domain entity.
/// Adds JSON serialisation and a factory to convert from the entity.
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.location,
    super.description,
    super.imageUrl,
  });

  // ── JSON de-serialisation ─────────────────────────────────────────────────

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  // ── JSON serialisation ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  // ── Convert from domain entity ────────────────────────────────────────────

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      location: project.location,
      description: project.description,
      imageUrl: project.imageUrl,
    );
  }
}
