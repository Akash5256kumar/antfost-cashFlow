import 'package:equatable/equatable.dart';

import '../../domain/entities/invoice_detail.dart';

/// Base class for all invoice-detail states.
sealed class InvoiceDetailState extends Equatable {
  const InvoiceDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any events have been dispatched.
class InvoiceDetailInitial extends InvoiceDetailState {
  const InvoiceDetailInitial();
}

/// Emitted while the invoice detail is being fetched.
class InvoiceDetailLoading extends InvoiceDetailState {
  const InvoiceDetailLoading();
}

/// Emitted when the invoice detail has been successfully loaded.
class InvoiceDetailSuccess extends InvoiceDetailState {
  final InvoiceDetail detail;

  const InvoiceDetailSuccess(this.detail);

  @override
  List<Object?> get props => [detail];
}

/// Emitted while the invoice PDF is being downloaded.
class InvoiceDetailDownloading extends InvoiceDetailState {
  /// The previously fetched detail, kept so the UI can still display content.
  final InvoiceDetail detail;

  const InvoiceDetailDownloading(this.detail);

  @override
  List<Object?> get props => [detail];
}

/// Emitted when the invoice PDF download has completed successfully.
class InvoiceDetailDownloaded extends InvoiceDetailState {
  final InvoiceDetail detail;

  const InvoiceDetailDownloaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

/// Emitted when an operation fails.
class InvoiceDetailError extends InvoiceDetailState {
  final String message;

  const InvoiceDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
