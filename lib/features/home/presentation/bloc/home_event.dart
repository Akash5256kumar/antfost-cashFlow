import 'package:equatable/equatable.dart';

/// Base class for all home BLoC events.
sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

/// Triggers an initial or refresh load of home screen data.
final class FetchHomeDataEvent extends HomeEvent {
  const FetchHomeDataEvent();

  @override
  List<Object?> get props => [];
}

/// Retries a previously failed home data load.
final class RetryHomeEvent extends HomeEvent {
  const RetryHomeEvent();

  @override
  List<Object?> get props => [];
}
