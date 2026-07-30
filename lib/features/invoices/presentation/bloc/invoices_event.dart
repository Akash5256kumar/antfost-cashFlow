import 'package:equatable/equatable.dart';

/// Base class for all invoice-list events.
sealed class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers the initial fetch of the invoice list.
class FetchInvoicesEvent extends InvoicesEvent {
  const FetchInvoicesEvent();
}

/// Applies a tab-based filter to the invoice list.
/// [filterIndex]: 0 = All, 1 = Receipt, 2 = VAT, 3 = VAT Invoice Ready.
class FilterInvoicesEvent extends InvoicesEvent {
  final int filterIndex;

  const FilterInvoicesEvent(this.filterIndex);

  @override
  List<Object?> get props => [filterIndex];
}

/// Filters the invoice list by [query] matching invoice id or order id.
class SearchInvoicesEvent extends InvoicesEvent {
  final String query;

  const SearchInvoicesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Retries the last failed fetch.
class RetryInvoicesEvent extends InvoicesEvent {
  const RetryInvoicesEvent();
}
