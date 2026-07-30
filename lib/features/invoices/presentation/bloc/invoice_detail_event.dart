import 'package:equatable/equatable.dart';

/// Base class for all invoice-detail events.
sealed class InvoiceDetailEvent extends Equatable {
  const InvoiceDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers a fetch of the full detail for [invoiceId].
class FetchInvoiceDetailEvent extends InvoiceDetailEvent {
  final String invoiceId;

  const FetchInvoiceDetailEvent(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

/// Triggers a PDF download for [invoiceId].
class DownloadInvoiceEvent extends InvoiceDetailEvent {
  final String invoiceId;

  const DownloadInvoiceEvent(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}
