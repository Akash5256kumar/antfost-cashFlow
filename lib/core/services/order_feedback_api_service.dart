import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class OrderFeedbackApiService {
  OrderFeedbackApiService(this._client);
  final ApiClient _client;

  Future<void> submitRating({
    required String orderId,
    required int overallRating,
    Map<String, int>? ratings,
    String? comment,
  }) async {
    try {
      await _client.post<Map<String, dynamic>>(
        '/orders/$orderId/rating',
        data: {
          'overallRating': overallRating,
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      throw ServerException(
        data is Map && data['message'] is String
            ? data['message'] as String
            : e.message ?? 'Unable to submit rating.',
      );
    }
  }
}
