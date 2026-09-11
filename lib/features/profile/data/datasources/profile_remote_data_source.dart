import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

/// Contract for the profile remote data source.
abstract class ProfileRemoteDataSource {
  /// Fetches the current user's profile from the API.
  ///
  /// Throws [ServerException] on failure.
  Future<UserProfileModel> getProfile();

  /// Sends updated profile data to the API.
  ///
  /// Returns `true` on success. Throws [ServerException] on failure.
  Future<bool> updateProfile(UserProfileModel profileModel);
}

/// Mock implementation that returns hard-coded dummy data after 300 ms.
///
/// Replace with a real Dio/Retrofit implementation once the backend is ready.
class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  @override
  Future<UserProfileModel> getProfile() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return UserProfileModel.fromEntity(
      const UserProfile(
        id: 'u1',
        name: 'Omar',
        email: 'omar@example.com',
        phone: '+971501234567',
        company: 'Omar Construction',
        avatarUrl: null,
        isKycVerified: true,
      ),
    );
  }

  @override
  Future<bool> updateProfile(UserProfileModel profileModel) async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

class ApiProfileRemoteDataSource implements ProfileRemoteDataSource {
  ApiProfileRemoteDataSource(this._client);
  final ApiClient _client;
  @override
  Future<UserProfileModel> getProfile() => _request(() async {
    final response = await _client.get<Map<String, dynamic>>('/me');
    if (response.data == null)
      throw const ServerException('Profile response is invalid.');
    return UserProfileModel.fromJson(response.data!);
  });
  @override
  Future<bool> updateProfile(UserProfileModel profile) => _request(() async {
    final response = await _client.dio.put<Map<String, dynamic>>(
      '/me',
      data: {
        'name': profile.name,
        'email': profile.email,
        'phone': profile.phone,
        'company': profile.company,
        if (profile.avatarUrl != null) 'avatarUrl': profile.avatarUrl,
      },
    );
    if (response.data == null)
      throw const ServerException('Profile update response is invalid.');
    return true;
  });
  Future<T> _request<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : error.message ?? 'Unable to load profile.';
      if (error.type == DioExceptionType.connectionError)
        throw NetworkException(message);
      throw ServerException(message);
    }
  }
}
