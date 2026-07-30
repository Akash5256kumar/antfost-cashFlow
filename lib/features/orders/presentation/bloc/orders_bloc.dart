import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import 'orders_event.dart';
import 'orders_state.dart';

/// BLoC responsible for loading, filtering, and searching orders.
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;

  OrdersBloc({required GetOrdersUseCase getOrdersUseCase})
      : _getOrdersUseCase = getOrdersUseCase,
        super(const OrdersInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<FilterOrdersEvent>(_onFilterOrders);
    on<SearchOrdersEvent>(_onSearchOrders);
    on<RetryOrdersEvent>(_onRetryOrders);
  }

  // ── Event handlers ─────────────────────────────────────────────────────

  Future<void> _onFetchOrders(
    FetchOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());

    final result = await _getOrdersUseCase(const NoParams());

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(
        OrdersSuccess(
          orders: orders,
          filteredOrders: orders,
          filterIndex: 0,
          searchQuery: '',
        ),
      ),
    );
  }

  void _onFilterOrders(
    FilterOrdersEvent event,
    Emitter<OrdersState> emit,
  ) {
    final current = state;
    if (current is! OrdersSuccess) return;

    final filtered = _applyFilters(
      allOrders: current.orders,
      filterIndex: event.filterIndex,
      searchQuery: current.searchQuery,
    );

    emit(
      OrdersSuccess(
        orders: current.orders,
        filteredOrders: filtered,
        filterIndex: event.filterIndex,
        searchQuery: current.searchQuery,
      ),
    );
  }

  void _onSearchOrders(
    SearchOrdersEvent event,
    Emitter<OrdersState> emit,
  ) {
    final current = state;
    if (current is! OrdersSuccess) return;

    final filtered = _applyFilters(
      allOrders: current.orders,
      filterIndex: current.filterIndex,
      searchQuery: event.query,
    );

    emit(
      OrdersSuccess(
        orders: current.orders,
        filteredOrders: filtered,
        filterIndex: current.filterIndex,
        searchQuery: event.query,
      ),
    );
  }

  Future<void> _onRetryOrders(
    RetryOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    await _onFetchOrders(const FetchOrdersEvent(), emit);
  }

  // ── Filter / search logic ──────────────────────────────────────────────

  /// Returns the subset of [allOrders] that satisfies both the status filter
  /// ([filterIndex]) and the text [searchQuery].
  List<Order> _applyFilters({
    required List<Order> allOrders,
    required int filterIndex,
    required String searchQuery,
  }) {
    var result = allOrders.toList();

    // Apply status filter first.
    switch (filterIndex) {
      case 1: // Active / inProgress
        result =
            result.where((o) => o.status == OrderStatusType.inProgress).toList();
        break;
      case 2: // Scheduled
        result =
            result.where((o) => o.status == OrderStatusType.scheduled).toList();
        break;
      case 3: // Completed
        result =
            result.where((o) => o.status == OrderStatusType.completed).toList();
        break;
      default: // 0 = All — no status filter
        break;
    }

    // Apply text search on orderId and grade (case-insensitive).
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (o) =>
                o.orderId.toLowerCase().contains(q) ||
                o.grade.toLowerCase().contains(q),
          )
          .toList();
    }

    return result;
  }
}
