import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Contract for the local (on-device) authentication data source.
abstract class AuthLocalDataSource {
  /// Persists [user] in the local cache.
  Future<void> cacheUser(UserModel user);

  /// Returns the most recently cached [UserModel].
  /// Throws [CacheException] when no user has been cached.
  Future<UserModel> getCachedUser();

  /// Removes the cached user from local storage.
  Future<void> clearCachedUser();
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with SharedPreferences / Hive once wired.
// ---------------------------------------------------------------------------

/// In-memory local data source used during development.
/// Uses a static field so the cache survives across instances within a session.
class MockAuthLocalDataSource implements AuthLocalDataSource {
  /// Holds the most recently cached user in memory.
  static UserModel? _cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    _cachedUser = user;
  }

  @override
  Future<UserModel> getCachedUser() async {
    final user = _cachedUser;
    if (user == null) {
      throw const CacheException('No user found in cache.');
    }
    return user;
  }

  @override
  Future<void> clearCachedUser() async {
    _cachedUser = null;
  }
}
