import 'package:equatable/equatable.dart';

/// Sealed base class for all events handled by [OrdersBloc].
sealed class OrdersEvent extends Equatable {
  const OrdersEvent();
}

/// Triggers the initial load of orders from the repository.
final class FetchOrdersEvent extends OrdersEvent {
  const FetchOrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Applies a status-based filter tab to the already-loaded orders list.
///
/// [filterIndex]:
///   - 0 = All
///   - 1 = Active (inProgress)
///   - 2 = Scheduled
///   - 3 = Completed
final class FilterOrdersEvent extends OrdersEvent {
  final int filterIndex;

  const FilterOrdersEvent(this.filterIndex);

  @override
  List<Object?> get props => [filterIndex];
}

/// Filters the displayed orders by a search [query] against orderId and grade.
final class SearchOrdersEvent extends OrdersEvent {
  final String query;

  const SearchOrdersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Re-triggers [FetchOrdersEvent] after an error.
final class RetryOrdersEvent extends OrdersEvent {
  const RetryOrdersEvent();

  @override
  List<Object?> get props => [];
}
