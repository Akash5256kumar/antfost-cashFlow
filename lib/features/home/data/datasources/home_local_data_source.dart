import '../../../../core/errors/exceptions.dart';
import '../models/home_data_model.dart';

/// Contract for the home local data source (cache).
abstract class HomeLocalDataSource {
  /// Returns the last cached [HomeDataModel].
  ///
  /// Throws [CacheException] when no cached data is available.
  Future<HomeDataModel> getCachedHomeData();

  /// Stores [homeData] in the local cache.
  Future<void> cacheHomeData(HomeDataModel homeData);
}

/// In-memory mock implementation. Data lives only for the app session.
class MockHomeLocalDataSource implements HomeLocalDataSource {
  HomeDataModel? _cache;

  @override
  Future<HomeDataModel> getCachedHomeData() async {
    if (_cache == null) {
      throw const CacheException('No cached home data available.');
    }
    return _cache!;
  }

  @override
  Future<void> cacheHomeData(HomeDataModel homeData) async {
    _cache = homeData;
  }
}
