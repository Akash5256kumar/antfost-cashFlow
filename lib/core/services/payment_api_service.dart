import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

/// A wallet attempt was refused before any payment record was created. The
/// draft order remains payable and the UI should offer the documented top-up
/// next action rather than treating it as a pending payment.
class InsufficientWalletBalanceException implements Exception {
  const InsufficientWalletBalanceException(this.message, this.data);

  final String message;
  final Map<String, dynamic> data;

  @override
  String toString() => message;
}

class PaymentApiService {
  PaymentApiService(this._client);
  final ApiClient _client;

  /// Checkout must be driven by the server: availability, wallet balance and
  /// the total can differ by method because of method-specific charges.
  Future<Map<String, dynamic>> methods({required String orderId}) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/payments/methods',
          queryParameters: {'orderId': orderId},
        );
        final data = response.data;
        if (data == null || data['items'] is! List) {
          throw const ServerException('Payment methods response is invalid.');
        }
        return data;
      });

  Future<Map<String, dynamic>> initiate({
    required String orderId,
    required String method,
    double? walletAmount,
    bool? termsAccepted,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/payments',
      data: {
        'orderId': orderId,
        'method': method,
        if (walletAmount != null) 'walletAmount': walletAmount,
        if (termsAccepted != null) 'termsAccepted': termsAccepted,
      },
    );
    final data = response.data;
    if (data == null || data['payment'] is! Map)
      throw const ServerException('Payment response is invalid.');
    return data;
  });

  Future<Map<String, dynamic>> status(String paymentId) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/payments/$paymentId',
    );
    if (response.data == null)
      throw const ServerException('Payment status response is invalid.');
    return response.data!;
  });

  Future<Map<String, dynamic>> submitProof({
    required String paymentId,
    required String proofFileId,
    String? bankReference,
    String? paidAt,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/payments/$paymentId/proof',
      data: {
        'proofFileId': proofFileId,
        if (bankReference != null) 'bankReference': bankReference,
        if (paidAt != null) 'paidAt': paidAt,
      },
    );
    if (response.data == null)
      throw const ServerException('Payment proof response is invalid.');
    return response.data!;
  });

  Future<T> _request<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : error.message ?? 'Unable to reach the payment service.';
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout)
        throw TimeoutException(message);
      if (error.type == DioExceptionType.connectionError)
        throw NetworkException(message);
      if (error.response?.statusCode == 402 && data is Map) {
        throw InsufficientWalletBalanceException(
          message,
          Map<String, dynamic>.from(data),
        );
      }
      throw ServerException(message);
    }
  }
}
