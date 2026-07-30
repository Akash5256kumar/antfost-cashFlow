import 'package:equatable/equatable.dart';

import '../../domain/entities/home_data.dart';

/// Base class for all home BLoC states.
sealed class HomeState extends Equatable {
  const HomeState();
}

/// The BLoC has not yet received any event.
final class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

/// Home data is being fetched.
final class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

/// Home data was fetched successfully.
final class HomeSuccess extends HomeState {
  final HomeData data;

  const HomeSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// The home data fetch failed.
final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
