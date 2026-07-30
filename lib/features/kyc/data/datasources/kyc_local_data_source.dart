import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/kyc_status.dart';
import '../models/kyc_status_model.dart';

/// Contract for the local KYC data source (cache layer).
abstract class KycLocalDataSource {
  /// Returns the last successfully fetched [KycStatus] from the in-memory cache.
  /// Throws [CacheException] when no cached data is available.
  Future<KycStatus> getCachedKycStatus();

  /// Persists a [KycStatus] to the in-memory cache.
  Future<void> cacheKycStatus(KycStatus status);

  /// Clears any previously cached [KycStatus].
  Future<void> clearCachedKycStatus();
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Hive/SharedPreferences when needed.
// ---------------------------------------------------------------------------

/// Mock local data source backed by an in-memory variable.
class MockKycLocalDataSource implements KycLocalDataSource {
  /// In-memory store for the most recently cached KYC status.
  KycStatusModel? _cachedStatus;

  @override
  Future<KycStatus> getCachedKycStatus() async {
    final cached = _cachedStatus;
    if (cached == null) {
      throw const CacheException('No cached KYC status found.');
    }
    return cached;
  }

  @override
  Future<void> cacheKycStatus(KycStatus status) async {
    _cachedStatus = KycStatusModel.fromEntity(status);
  }

  @override
  Future<void> clearCachedKycStatus() async {
    _cachedStatus = null;
  }
}
