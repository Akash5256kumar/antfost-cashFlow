import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';

/// Contract for the profile local data source (cache).
abstract class ProfileLocalDataSource {
  /// Returns the last cached [UserProfileModel].
  ///
  /// Throws [CacheException] when no cached data is available.
  Future<UserProfileModel> getCachedProfile();

  /// Stores [profileModel] in the local cache.
  Future<void> cacheProfile(UserProfileModel profileModel);
}

/// In-memory mock implementation. Data lives only for the app session.
class MockProfileLocalDataSource implements ProfileLocalDataSource {
  UserProfileModel? _cache;

  @override
  Future<UserProfileModel> getCachedProfile() async {
    if (_cache == null) {
      throw const CacheException('No cached profile data available.');
    }
    return _cache!;
  }

  @override
  Future<void> cacheProfile(UserProfileModel profileModel) async {
    _cache = profileModel;
  }
}
