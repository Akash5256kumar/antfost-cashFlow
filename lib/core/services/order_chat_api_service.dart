import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class OrderChatApiService {
  OrderChatApiService(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> loadMessages(String orderId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/orders/$orderId/messages',
      );
      final items = response.data?['items'];
      if (items is! List) throw const ServerException('Messages response is invalid.');
      return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
    } on DioException catch (e) {
      throw _error(e, 'Unable to load order messages.');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String orderId, String body) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/orders/$orderId/messages',
        data: {'body': body},
      );
      if (response.data == null) throw const ServerException('Message response is invalid.');
      return response.data!;
    } on DioException catch (e) {
      throw _error(e, 'Message could not be sent. Please try again.');
    }
  }

  ServerException _error(DioException e, String fallback) {
    final data = e.response?.data;
    return ServerException(data is Map && data['message'] is String ? data['message'] as String : e.message ?? fallback);
  }
}
