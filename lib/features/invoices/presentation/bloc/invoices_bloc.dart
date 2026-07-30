import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices_use_case.dart';
import 'invoices_event.dart';
import 'invoices_state.dart';

/// BLoC responsible for the invoice list screen.
///
/// Filter indices:
///   0 → All
///   1 → Receipt type
///   2 → VAT type
///   3 → VAT Invoice Ready status
class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final GetInvoicesUseCase getInvoicesUseCase;

  InvoicesBloc({required this.getInvoicesUseCase})
      : super(const InvoicesInitial()) {
    on<FetchInvoicesEvent>(_onFetchInvoices);
    on<FilterInvoicesEvent>(_onFilterInvoices);
    on<SearchInvoicesEvent>(_onSearchInvoices);
    on<RetryInvoicesEvent>(_onRetryInvoices);
  }

  // -------------------------------------------------------------------------
  // Event handlers
  // -------------------------------------------------------------------------

  Future<void> _onFetchInvoices(
    FetchInvoicesEvent event,
    Emitter<InvoicesState> emit,
  ) async {
    emit(const InvoicesLoading());
    final result = await getInvoicesUseCase(const NoParams());
    result.fold(
      (failure) => emit(InvoicesError(failure.message)),
      (invoices) => emit(
        InvoicesSuccess(
          allInvoices: invoices,
          filteredInvoices: invoices,
          filterIndex: 0,
          searchQuery: '',
        ),
      ),
    );
  }

  void _onFilterInvoices(
    FilterInvoicesEvent event,
    Emitter<InvoicesState> emit,
  ) {
    final current = state;
    if (current is! InvoicesSuccess) return;

    final filtered = _applyFilterAndSearch(
      all: current.allInvoices,
      filterIndex: event.filterIndex,
      query: current.searchQuery,
    );

    emit(
      InvoicesSuccess(
        allInvoices: current.allInvoices,
        filteredInvoices: filtered,
        filterIndex: event.filterIndex,
        searchQuery: current.searchQuery,
      ),
    );
  }

  void _onSearchInvoices(
    SearchInvoicesEvent event,
    Emitter<InvoicesState> emit,
  ) {
    final current = state;
    if (current is! InvoicesSuccess) return;

    final filtered = _applyFilterAndSearch(
      all: current.allInvoices,
      filterIndex: current.filterIndex,
      query: event.query,
    );

    emit(
      InvoicesSuccess(
        allInvoices: current.allInvoices,
        filteredInvoices: filtered,
        filterIndex: current.filterIndex,
        searchQuery: event.query,
      ),
    );
  }

  Future<void> _onRetryInvoices(
    RetryInvoicesEvent event,
    Emitter<InvoicesState> emit,
  ) async {
    await _onFetchInvoices(const FetchInvoicesEvent(), emit);
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// Applies the active [filterIndex] and [query] to [all].
  List<Invoice> _applyFilterAndSearch({
    required List<Invoice> all,
    required int filterIndex,
    required String query,
  }) {
    // Step 1: tab filter.
    List<Invoice> result;
    switch (filterIndex) {
      case 1:
        // Receipt type invoices.
        result = all
            .where((inv) => inv.types.contains(InvoiceType.receipt))
            .toList();
        break;
      case 2:
        // VAT type invoices.
        result = all
            .where((inv) => inv.types.contains(InvoiceType.vat))
            .toList();
        break;
      case 3:
        // VAT Invoice Ready status.
        result = all
            .where((inv) => inv.status == InvoiceStatus.vatInvoiceReady)
            .toList();
        break;
      default:
        // All invoices (index 0).
        result = List.of(all);
    }

    // Step 2: search filter.
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isNotEmpty) {
      result = result.where((inv) {
        return inv.id.toLowerCase().contains(trimmedQuery) ||
            inv.orderId.toLowerCase().contains(trimmedQuery);
      }).toList();
    }

    return result;
  }
}
