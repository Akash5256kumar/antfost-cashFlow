import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class AccountApiService {
  AccountApiService(this._client);
  final ApiClient _client;

  Future<void> requestDeletion({required String reason}) async {
    try {
      await _client.post<Map<String, dynamic>>(
        '/account-deletion-requests',
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      throw ServerException(
        data is Map && data['message'] is String
            ? data['message'] as String
            : e.message ?? 'Unable to submit account deactivation request.',
      );
    }
  }
}
