import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'secure_storage_service.dart';

/// Shared HTTP client for the Mobile API.
///
/// Configure the API host per environment; the Mobile API path is always
/// appended automatically:
///
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
///
/// This produces `https://api.example.com/api/mobile/v1`. A non-routable
/// dummy host is used until backend supplies the real environment URL.
class ApiClient {
  ApiClient({
    String? baseUrl,
    Dio? dio,
    SecureStorageService? secureStorage,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 30),
  }) : _secureStorage = secureStorage,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: ApiBaseUrl.resolve(baseUrl),
               connectTimeout: connectTimeout,
               receiveTimeout: receiveTimeout,
               headers: const {
                 Headers.acceptHeader: Headers.jsonContentType,
                 Headers.contentTypeHeader: Headers.jsonContentType,
               },
             ),
           ) {
    _dio.interceptors.add(
      _BearerTokenInterceptor(
        tokenProvider: () async =>
            _accessToken ?? await _secureStorage?.readAccessToken(),
        onUnauthorized: () async {
          _accessToken = null;
          await _secureStorage?.clearTokens();
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio _dio;
  final SecureStorageService? _secureStorage;
  String? _accessToken;

  /// Exposes Dio only for cases that need an upload stream or cancellation.
  Dio get dio => _dio;

  void setAccessToken(String token) => _accessToken = token;

  /// Hydrates the in-memory token once at app launch. The interceptor still
  /// falls back to secure storage, so requests remain safe if this is missed.
  Future<void> restoreAccessToken() async {
    _accessToken = await _secureStorage?.readAccessToken();
  }

  void clearAccessToken() => _accessToken = null;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.get<T>(
    path,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> patch<T>(String path, {Object? data, Options? options}) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(String path, {Options? options}) =>
      _dio.delete<T>(path, options: options);
}

/// API host configuration. The Mobile API path is appended when callers pass
/// only the host; a complete API URL is also accepted without duplication.
abstract final class ApiBaseUrl {
  static const String mobilePath = '/api/mobile/v1';
  static const String _environmentHost = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://rmb.testingenv.co.in:81/api/mobile/v1',
  );

  static String get current => resolve(_environmentHost);

  static String resolve(String? host) {
    final normalizedHost = (host ?? '').trim().replaceFirst(RegExp(r'/+$'), '');
    return normalizedHost.isEmpty
        ? 'https://rmb.testingenv.co.in:81$mobilePath'
        : normalizedHost.endsWith(mobilePath)
        ? normalizedHost
        : '$normalizedHost$mobilePath';
  }
}

class _BearerTokenInterceptor extends Interceptor {
  _BearerTokenInterceptor({
    required this.tokenProvider,
    required this.onUnauthorized,
  });

  final FutureOr<String?> Function() tokenProvider;
  final FutureOr<void> Function() onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401 &&
        error.requestOptions.headers['Authorization'] != null) {
      await onUnauthorized();
    }
    handler.next(error);
  }
}
