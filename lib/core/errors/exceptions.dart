class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred.']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network connection unavailable.']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache read/write failed.']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication error.']);

  @override
  String toString() => message;
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Request timed out.']);

  @override
  String toString() => message;
}
