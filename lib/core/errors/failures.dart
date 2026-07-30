import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Unable to connect. Please check your internet.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again later.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please sign in again.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Taking too long. Please try again.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
