import 'package:dio/dio.dart';
import 'dart:io';

import '../uploads/document_picker_service.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

/// API error details used by the order-review UI to give the customer a
/// meaningful recovery action instead of one generic snackbar.
class OrderApiException implements Exception {
  const OrderApiException({
    required this.code,
    required this.message,
    this.fields = const {},
  });

  final String code;
  final String message;
  final Map<String, String> fields;

  @override
  String toString() => message;
}

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

  Future<List<Map<String, dynamic>>> pumpTypes({String? locationId}) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/pump-types',
          queryParameters: {
            if (locationId != null && locationId.isNotEmpty)
              'locationId': locationId,
          },
        );
        final items = response.data?['items'];
        if (items is! List) {
          throw const ServerException('Pump types response is invalid.');
        }
        return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
      });

  Future<Map<String, dynamic>> pumpSizes({
    required String pumpType,
    String? locationId,
  }) => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/pump-sizes',
      queryParameters: {
        'pumpType': pumpType,
        if (locationId != null && locationId.isNotEmpty)
          'locationId': locationId,
      },
    );
    if (response.data == null) {
      throw const ServerException('Pump sizes response is invalid.');
    }
    return response.data!;
  });

  /// Reserves an upload URL, uploads bytes, and returns the one-time file ID
  /// which must be attached to the order payload.
  Future<String> uploadSiteAccessFile({
    required SelectedDocument document,
    required String purpose,
  }) => _request(() async {
    final reserved = await _client.post<Map<String, dynamic>>(
      '/site-access/upload-urls',
      data: {
        'purpose': purpose,
        'fileName': document.name,
        'mimeType': document.mimeType,
        'fileSizeBytes': document.sizeBytes,
      },
    );
    final data = reserved.data;
    final fileId = data?['fileId'];
    final uploadUrl = data?['uploadUrl'];
    if (fileId is! String || uploadUrl is! String || document.path == null) {
      throw const ServerException('Site-access upload response is invalid.');
    }
    final file = File(document.path!);
    if (!await file.exists()) {
      throw const ServerException('The selected file is no longer available.');
    }
    // The mobile API's direct upload URL is still authenticated. Reuse the
    // shared client so its bearer-token interceptor is applied; a standalone
    // Dio instance causes the server to return `Unauthenticated` here.
    await _client.dio.put<void>(
      uploadUrl,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentTypeHeader: document.mimeType,
          Headers.contentLengthHeader: document.sizeBytes,
        },
      ),
    );
    return fileId;
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

  Future<Map<String, dynamic>> operations(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'deliveryStatus': 'In Progress',
      'siteProgress': {
        'checkpoint': 'Arrived on Site',
        'startedAt': '09:00 AM',
        'completedAt': null,
      },
      'resources': [
        {
          'label': 'Truck #12',
          'type': 'Mixer',
          'status': 'Pouring',
          'eta': null,
        },
        {
          'label': 'Truck #15',
          'type': 'Mixer',
          'status': 'En Route',
          'eta': '10:30 AM',
        },
        {
          'label': 'Pump #2',
          'type': 'Pump',
          'status': 'Setup Complete',
          'eta': null,
        }
      ]
    };
  }

  Future<Map<String, dynamic>> qualityCheck(String orderId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId/quality-check',
        );
        if (response.data == null) {
          throw const ServerException('Quality check response is invalid.');
        }
        return response.data!;
      });

  Future<List<Map<String, dynamic>>> deliverySignatures(String orderId) =>
      _request(() async {
        final response = await _client.get<Map<String, dynamic>>(
          '/orders/$orderId/delivery-signatures',
        );
        final values = response.data?['signatures'];
        if (values is! List) {
          throw const ServerException(
            'Delivery signatures response is invalid.',
          );
        }
        return values.whereType<Map>().map(Map<String, dynamic>.from).toList();
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
      if (body is Map) {
        final rawFields = body['fields'];
        final fields = rawFields is Map
            ? rawFields.map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              )
            : const <String, String>{};
        throw OrderApiException(
          code: body['code']?.toString() ?? 'ORDER_REQUEST_FAILED',
          message: message,
          fields: fields,
        );
      }
      throw ServerException(message);
    }
  }
}
