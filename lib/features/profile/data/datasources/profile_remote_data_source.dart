import '../../../../core/errors/exceptions.dart';
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
