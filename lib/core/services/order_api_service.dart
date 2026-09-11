import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class OrderApiService {
  OrderApiService(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> mixCodes({
    required String projectId,
    required String locationId,
    String? query,
  }) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/mix-codes',
      queryParameters: {
        'projectId': projectId,
        'locationId': locationId,
        if (query != null && query.isNotEmpty) 'query': query,
      },
    );
    final items = response.data?['items'];
    if (items is! List)
      throw const ServerException('Mix catalogue response is invalid.');
    return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
  });

  Future<List<Map<String, dynamic>>> timeWindows({
    required String projectId,
    required String locationId,
    required String mixCode,
    required double quantityM3,
    required String date,
  }) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/delivery-time-windows',
      queryParameters: {
        'projectId': projectId,
        'locationId': locationId,
        'mixCode': mixCode,
        'quantityM3': quantityM3,
        'date': date,
      },
    );
    final items = response.data?['items'];
    if (items is! List)
      throw const ServerException('Time windows response is invalid.');
    return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
  });

  Future<List<Map<String, dynamic>>> structureTypes({
    required String projectId,
    required String mixCode,
  }) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/structure-types',
      queryParameters: {'projectId': projectId, 'mixCode': mixCode},
    );
    final items = response.data?['items'];
    if (items is! List)
      throw const ServerException('Structure types response is invalid.');
    return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
  });

  Future<Map<String, dynamic>> createDraft(Map<String, dynamic> payload) =>
      _request(() async {
        final response = await _client.post<Map<String, dynamic>>(
          '/orders',
          data: payload,
        );
        final data = response.data?['order'];
        if (data is! Map)
          throw const ServerException('Order creation response is invalid.');
        return Map<String, dynamic>.from(data);
      });

  Future<Map<String, dynamic>> priceBreakdown(String orderId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId/price-breakdown',
        );
        final data = response.data;
        if (data == null)
          throw const ServerException('Price breakdown response is invalid.');
        return data;
      });

  Future<Map<String, dynamic>> tracking(String orderId) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/orders/$orderId/tracking',
    );
    if (response.data == null)
      throw const ServerException('Tracking response is invalid.');
    return response.data!;
  });

  Future<Map<String, dynamic>> operations(String orderId) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/orders/$orderId/operations',
    );
    if (response.data == null)
      throw const ServerException('Operations response is invalid.');
    return response.data!;
  });

  Future<Map<String, dynamic>> scheduleProposal(String orderId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId/schedule-proposal',
        );
        if (response.data == null)
          throw const ServerException('Schedule proposal response is invalid.');
        return response.data!;
      });

  Future<Map<String, dynamic>> acceptScheduleProposal(String orderId) =>
      _request(() async {
        final response = await _client.patch<Map<String, dynamic>>(
          '/orders/$orderId/schedule-proposal',
          data: const {'action': 'accept'},
        );
        if (response.data == null)
          throw const ServerException(
            'Schedule acceptance response is invalid.',
          );
        return response.data!;
      });

  Future<Map<String, dynamic>> operationsAgreement(String orderId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId/operations-agreement',
        );
        if (response.data == null)
          throw const ServerException(
            'Operations agreement response is invalid.',
          );
        return response.data!;
      });

  Future<Map<String, dynamic>> acceptOperationsAgreement(String orderId) =>
      _request(() async {
        final response = await _client.post<Map<String, dynamic>>(
          '/orders/$orderId/operations-agreement/acceptance',
          data: const {'accepted': true},
        );
        if (response.data == null)
          throw const ServerException(
            'Agreement acceptance response is invalid.',
          );
        return response.data!;
      });

  Future<T> _request<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (error) {
      final body = error.response?.data;
      final message = body is Map && body['message'] is String
          ? body['message'] as String
          : error.message ?? 'Unable to reach the server.';
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout)
        throw TimeoutException(message);
      if (error.type == DioExceptionType.connectionError)
        throw NetworkException(message);
      throw ServerException(message);
    }
  }
}
