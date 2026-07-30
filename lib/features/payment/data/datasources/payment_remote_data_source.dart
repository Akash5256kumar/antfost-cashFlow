import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

/// Contract for the remote payment data source.
abstract class PaymentRemoteDataSource {
  /// Initiates a payment and returns a [PaymentModel].
  /// Throws [ServerException] on failure.
  Future<PaymentModel> initiatePayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  });

  /// Verifies the status of a payment identified by [paymentId].
  /// Returns the updated [PaymentModel]. Throws [ServerException] on failure.
  Future<PaymentModel> verifyPayment(String paymentId);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Dio/Retrofit once the API is ready.
// ---------------------------------------------------------------------------

/// Simulates a 1 000 ms payment initiation delay.
Future<void> _fakeInitiateDelay() =>
    Future.delayed(const Duration(milliseconds: 1000));

/// Simulates a 500 ms payment verification delay.
Future<void> _fakeVerifyDelay() =>
    Future.delayed(const Duration(milliseconds: 500));

/// Mock remote data source for development / testing purposes.
class MockPaymentRemoteDataSource implements PaymentRemoteDataSource {
  @override
  Future<PaymentModel> initiatePayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
  }) async {
    await _fakeInitiateDelay();
    return PaymentModel(
      id: 'pay_001',
      orderId: orderId,
      amount: amount,
      method: method,
      status: PaymentStatus.success,
      transactionId: 'TXN_MOCK_001',
    );
  }

  @override
  Future<PaymentModel> verifyPayment(String paymentId) async {
    await _fakeVerifyDelay();
    return PaymentModel(
      id: paymentId,
      orderId: 'ord-001',
      amount: 22785.00,
      method: PaymentMethod.wallet,
      status: PaymentStatus.success,
      transactionId: 'TXN_MOCK_001',
    );
  }
}
