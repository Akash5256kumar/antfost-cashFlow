import 'package:equatable/equatable.dart';

import '../../domain/entities/invoice.dart';

/// Base class for all invoice-list states.
sealed class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any events have been dispatched.
class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

/// Indicates that an asynchronous operation is in progress.
class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

/// Emitted when invoices have been successfully loaded.
///
/// - [allInvoices]       — the full unfiltered list.
/// - [filteredInvoices]  — the list after applying filter and search.
/// - [filterIndex]       — the currently active tab index.
/// - [searchQuery]       — the currently active search string.
class InvoicesSuccess extends InvoicesState {
  final List<Invoice> allInvoices;
  final List<Invoice> filteredInvoices;
  final int filterIndex;
  final String searchQuery;

  const InvoicesSuccess({
    required this.allInvoices,
    required this.filteredInvoices,
    required this.filterIndex,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [
        allInvoices,
        filteredInvoices,
        filterIndex,
        searchQuery,
      ];
}

/// Emitted when an operation fails.
class InvoicesError extends InvoicesState {
  final String message;

  const InvoicesError(this.message);

  @override
  List<Object?> get props => [message];
}
