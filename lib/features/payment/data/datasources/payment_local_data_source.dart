import '../../../../core/errors/exceptions.dart';
import '../models/payment_model.dart';

/// Contract for the local payment data source (cache layer).
abstract class PaymentLocalDataSource {
  /// Returns the last cached [PaymentModel].
  /// Throws [CacheException] if no cached data exists.
  Future<PaymentModel> getCachedPayment(String paymentId);

  /// Stores [payment] in the in-memory cache keyed by its id.
  Future<void> cachePayment(PaymentModel payment);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Hive/SharedPreferences when wired.
// ---------------------------------------------------------------------------

/// In-memory mock local data source. Data is lost when the app restarts.
class MockPaymentLocalDataSource implements PaymentLocalDataSource {
  final Map<String, PaymentModel> _cache = {};

  @override
  Future<PaymentModel> getCachedPayment(String paymentId) async {
    final payment = _cache[paymentId];
    if (payment == null) {
      throw CacheException('No cached payment found for id: $paymentId.');
    }
    return payment;
  }

  @override
  Future<void> cachePayment(PaymentModel payment) async {
    _cache[payment.id] = payment;
  }
}
