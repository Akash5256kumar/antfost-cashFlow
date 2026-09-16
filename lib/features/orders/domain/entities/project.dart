import 'package:equatable/equatable.dart';

/// Domain entity representing a customer construction project / delivery site.
/// Pure Dart — no Flutter or external framework imports.
class Project extends Equatable {
  final String id;
  final String name;
  final String location;
  final String? description;
  final String? imageUrl;

  const Project({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, location, description, imageUrl];
}
