import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';

/// Sealed base class for all states emitted by [OrdersBloc].
sealed class OrdersState extends Equatable {
  const OrdersState();
}

/// Initial state before any fetch has been requested.
final class OrdersInitial extends OrdersState {
  const OrdersInitial();

  @override
  List<Object?> get props => [];
}

/// Emitted while orders are being fetched from the repository.
final class OrdersLoading extends OrdersState {
  const OrdersLoading();

  @override
  List<Object?> get props => [];
}

/// Emitted when orders have been successfully loaded and (optionally) filtered.
///
/// [orders]         — the complete, unfiltered list returned by the repository.
/// [filteredOrders] — the subset currently visible after filter + search.
/// [filterIndex]    — the active filter tab index (0=All, 1=Active, …).
/// [searchQuery]    — the current search string (may be empty).
final class OrdersSuccess extends OrdersState {
  final List<Order> orders;
  final List<Order> filteredOrders;
  final int filterIndex;
  final String searchQuery;

  const OrdersSuccess({
    required this.orders,
    required this.filteredOrders,
    required this.filterIndex,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [orders, filteredOrders, filterIndex, searchQuery];
}

/// Emitted when the fetch fails.
final class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
