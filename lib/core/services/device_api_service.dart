import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import 'api_client.dart';

/// Service to register and unregister devices for push notifications
class DeviceApiService {
  DeviceApiService(this._client);
  final ApiClient _client;

  /// Registers the device for push notifications.
  /// Call right after sign-in with the FCM token, and again when Firebase rotates it.
  Future<void> registerDevice({
    required String token,
    required String platform,
    required String deviceName,
    required String appVersion,
  }) async {
    try {
      await _client.post<Map<String, dynamic>>(
        '/devices',
        data: {
          'token': token,
          'platform': platform,
          'deviceName': deviceName,
          'appVersion': appVersion,
        },
      );
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : error.message ?? 'Unable to register device for notifications.';
      throw ServerException(message);
    }
  }

  /// Removes the device token.
  /// Call on sign-out, or when the user disables notifications.
  Future<void> removeDevice(String token) async {
    try {
      await _client.delete<Map<String, dynamic>>(
        '/devices',
        queryParameters: {'token': token},
      );
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : error.message ?? 'Unable to remove device for notifications.';
      throw ServerException(message);
    }
  }
}
