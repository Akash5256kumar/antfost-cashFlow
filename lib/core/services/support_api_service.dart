import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class SupportApiService {
  SupportApiService(this._client);
  final ApiClient _client;

  Future<void> submitTicket({
    required String subject,
    String? orderRef,
    required String message,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/support/tickets',
        data: {
          'subject': subject,
          if (orderRef != null && orderRef.isNotEmpty) 'orderRef': orderRef,
          'message': message,
        },
      );
      if (response.data?['ticketId'] == null)
        throw const ServerException('Support ticket response is invalid.');
    } on DioException catch (error) {
      final data = error.response?.data;
      throw ServerException(
        data is Map && data['message'] is String
            ? data['message'] as String
            : error.message ?? 'Unable to submit support ticket.',
      );
    }
  }
}
