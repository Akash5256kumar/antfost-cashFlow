import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'app_demo_service.dart';
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
    FutureOr<void> Function()? onSessionExpired,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 30),
  }) : _secureStorage = secureStorage,
       _onSessionExpired = onSessionExpired,
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
    // Add logging first so its error handler receives the already-sanitised
    // response from the bearer interceptor (Dio runs error interceptors in
    // reverse registration order).
    if (kDebugMode) {
      _dio.interceptors.add(_ApiDebugLogInterceptor());
    }
    _dio.interceptors.add(
      _BearerTokenInterceptor(
        tokenProvider: () async =>
            _accessToken ?? await _secureStorage?.readAccessToken(),
        onUnauthorized: () async {
          _accessToken = null;
          await _secureStorage?.clearTokens();
          if (AppDemoService.isDemoMode) {
            return;
          }
          if (!_hasHandledUnauthorized) {
            _hasHandledUnauthorized = true;
            await _onSessionExpired?.call();
          }
        },
      ),
    );
  }

  final Dio _dio;
  final SecureStorageService? _secureStorage;
  final FutureOr<void> Function()? _onSessionExpired;
  String? _accessToken;
  bool _hasHandledUnauthorized = false;

  /// Exposes Dio only for cases that need an upload stream or cancellation.
  Dio get dio => _dio;

  void setAccessToken(String token) {
    _accessToken = token;
    _hasHandledUnauthorized = false;
  }

  /// Hydrates the in-memory token once at app launch. The interceptor still
  /// falls back to secure storage, so requests remain safe if this is missed.
  Future<void> restoreAccessToken() async {
    _accessToken = await _secureStorage?.readAccessToken();
  }

  void clearAccessToken() {
    _accessToken = null;
    _hasHandledUnauthorized = false;
  }

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

  Future<Response<T>> put<T>(String path, {Object? data, Options? options}) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
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
    _sanitizeServerError(error);
    handler.next(error);
  }

  /// A customer must never see server paths, framework stack traces, or other
  /// implementation details. Keep the HTTP status for feature-specific logic,
  /// but replace every 5xx body with one safe, actionable message.
  void _sanitizeServerError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = data is Map
        ? data['message']?.toString()
        : data?.toString();
    final looksInternal =
        message != null &&
        RegExp(
          r'SQLSTATE|deadlock found|mysql|insert ignore into|laravel\.log|/var/www/|stack trace',
          caseSensitive: false,
        ).hasMatch(message);
    if ((statusCode == null || statusCode < 500) && !looksInternal) {
      return;
    }
    response?.data = {
      'code': 'SERVICE_UNAVAILABLE',
      'message':
          'We are having trouble loading this right now. Please try again.',
    };
  }
}

/// Debug-only paired API logging. Calls still run concurrently; only their
/// output is grouped so each response appears beside its own request.
class _ApiDebugLogInterceptor extends Interceptor {
  static const _startedAtKey = '_apiDebugStartedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _printPair(
      request: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      responseBody: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _printPair(
      request: error.requestOptions,
      statusCode: error.response?.statusCode,
      statusMessage: error.response?.statusMessage ?? error.message,
      responseBody: error.response?.data,
      errorType: error.type.name,
    );
    handler.next(error);
  }

  void _printPair({
    required RequestOptions request,
    required int? statusCode,
    required String? statusMessage,
    required Object? responseBody,
    String? errorType,
  }) {
    final startedAt = request.extra[_startedAtKey];
    final duration = startedAt is DateTime
        ? DateTime.now().difference(startedAt).inMilliseconds
        : null;
    final durationLabel = duration == null ? '' : ' ${duration}ms';
    final errorLabel = errorType == null ? '' : ' error=$errorType';
    debugPrint('API ${request.method} ${request.uri}$durationLabel$errorLabel');
    debugPrint('  Request: ${request.data ?? '(no body)'}');
    debugPrint(
      '  Response: ${statusCode ?? 'no status'} ${statusMessage ?? ''}',
    );
    debugPrint('  Body: ${responseBody ?? '(empty)'}');
  }
}
