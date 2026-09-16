import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

/// API payload/result types for the current Projects and Saved Locations UI.
/// They intentionally mirror the Mobile API contract rather than UI labels.
class ProjectLocationPayload {
  const ProjectLocationPayload({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
  });

  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String contactName;
  final String contactPhone;

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'contactName': contactName,
    'contactPhone': contactPhone,
  };
}

class SavedLocation {
  const SavedLocation({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    required this.activeOrdersCount,
    required this.isDefault,
    this.imageUrl,
  });

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
    id: json['id'].toString(),
    projectId: json['projectId'].toString(),
    projectName: json['projectName'] as String? ?? '',
    name: json['name'] as String? ?? '',
    address: json['address'] as String? ?? '',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    contactName: json['contactName'] as String? ?? '',
    contactPhone: json['contactPhone'] as String? ?? '',
    activeOrdersCount: (json['activeOrdersCount'] as num?)?.toInt() ?? 0,
    isDefault: json['isDefault'] as bool? ?? false,
    imageUrl: json['imageUrl'] as String?,
  );

  final String id;
  final String projectId;
  final String projectName;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String contactName;
  final String contactPhone;
  final int activeOrdersCount;
  final bool isDefault;
  final String? imageUrl;
}

class CreatedProject {
  const CreatedProject({
    required this.id,
    required this.name,
    required this.locations,
  });

  factory CreatedProject.fromJson(Map<String, dynamic> json) {
    final rawLocations = json['locations'];
    return CreatedProject(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      locations: rawLocations is List
          ? rawLocations.whereType<Map>().map((item) {
              final value = Map<String, dynamic>.from(item);
              return CreatedProjectLocation(
                id: value['id'].toString(),
                name: value['name'] as String? ?? '',
                address: value['address'] as String? ?? '',
                latitude: (value['latitude'] as num?)?.toDouble() ?? 0,
                longitude: (value['longitude'] as num?)?.toDouble() ?? 0,
                contactName: '',
                contactPhone: '',
              );
            }).toList()
          : const [],
    );
  }

  final String id;
  final String name;
  final List<CreatedProjectLocation> locations;
}

class CreatedProjectLocation extends ProjectLocationPayload {
  const CreatedProjectLocation({
    required this.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.contactName,
    required super.contactPhone,
  });

  final String id;
}

class ProjectLocationApiService {
  ProjectLocationApiService(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> getProjectDetails(String projectId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/projects/$projectId',
          queryParameters: const {'recentOrdersLimit': 5},
        );
        if (response.data == null)
          throw const ServerException('Project details response is invalid.');
        return response.data!;
      });

  Future<CreatedProject> createProject({
    required String name,
    required String projectType,
    required List<ProjectLocationPayload> locations,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/projects',
      data: {
        'name': name,
        'projectType': projectType.toLowerCase(),
        'locations': locations.map((location) => location.toJson()).toList(),
      },
    );
    final data = response.data;
    if (data == null || data['id'] == null) {
      throw const ServerException('Project creation response is invalid.');
    }
    return CreatedProject.fromJson(data);
  });

  Future<List<SavedLocation>> getLocations({
    String? projectId,
    String? query,
  }) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/locations',
      queryParameters: {
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
        'page': 1,
        'pageSize': 100,
      },
    );
    final items = response.data?['items'];
    if (items is! List)
      throw const ServerException('Locations response is invalid.');
    return items.whereType<Map>().map((item) {
      return SavedLocation.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  });

  Future<SavedLocation> addLocation({
    required String projectId,
    required ProjectLocationPayload location,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/projects/$projectId/locations',
      data: location.toJson(),
    );
    final data = response.data;
    if (data == null)
      throw const ServerException('Location creation response is invalid.');
    return SavedLocation.fromJson(data);
  });

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final body = error.response?.data;
      final message = body is Map && body['message'] is String
          ? body['message'] as String
          : error.message ?? 'Unable to reach the server.';
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw TimeoutException(message);
      }
      if (error.type == DioExceptionType.connectionError) {
        throw NetworkException(message);
      }
      throw ServerException(message);
    }
  }
}
