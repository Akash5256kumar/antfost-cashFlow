import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

/// Contract for the local (cache) data source used by [OrdersRepositoryImpl].
abstract class OrdersLocalDataSource {
  /// Returns the previously cached list of orders.
  /// Throws [CacheException] if no cached data is available.
  Future<List<OrderModel>> getCachedOrders();

  /// Stores [orders] in the in-memory cache for offline access.
  Future<void> cacheOrders(List<OrderModel> orders);

  /// Removes all cached orders.
  Future<void> clearCache();
}

/// Mock in-memory implementation of [OrdersLocalDataSource].
/// Intended for use while a proper persistence layer (e.g. Hive/SharedPrefs)
/// is not yet wired up.
class MockOrdersLocalDataSource implements OrdersLocalDataSource {
  /// In-memory store; null means no data has been cached yet.
  List<OrderModel>? _cachedOrders;

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    final cached = _cachedOrders;
    if (cached == null) {
      throw const CacheException('No cached orders available.');
    }
    return List<OrderModel>.from(cached);
  }

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    _cachedOrders = List<OrderModel>.from(orders);
  }

  @override
  Future<void> clearCache() async {
    _cachedOrders = null;
  }
}
