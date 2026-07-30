class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network connection unavailable.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache read/write failed.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication error.']);
}

class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Request timed out.']);
}
