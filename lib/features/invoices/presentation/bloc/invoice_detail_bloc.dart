import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/download_invoice_use_case.dart';
import '../../domain/usecases/get_invoice_detail_use_case.dart';
import 'invoice_detail_event.dart';
import 'invoice_detail_state.dart';

/// BLoC responsible for the invoice detail screen.
/// Handles both the detail fetch and the PDF download independently.
class InvoiceDetailBloc extends Bloc<InvoiceDetailEvent, InvoiceDetailState> {
  final GetInvoiceDetailUseCase getInvoiceDetailUseCase;
  final DownloadInvoiceUseCase downloadInvoiceUseCase;

  InvoiceDetailBloc({
    required this.getInvoiceDetailUseCase,
    required this.downloadInvoiceUseCase,
  }) : super(const InvoiceDetailInitial()) {
    on<FetchInvoiceDetailEvent>(_onFetchInvoiceDetail);
    on<DownloadInvoiceEvent>(_onDownloadInvoice);
  }

  // -------------------------------------------------------------------------
  // Event handlers
  // -------------------------------------------------------------------------

  Future<void> _onFetchInvoiceDetail(
    FetchInvoiceDetailEvent event,
    Emitter<InvoiceDetailState> emit,
  ) async {
    emit(const InvoiceDetailLoading());
    final result = await getInvoiceDetailUseCase(
      GetInvoiceDetailParams(invoiceId: event.invoiceId),
    );
    result.fold(
      (failure) => emit(InvoiceDetailError(failure.message)),
      (detail) => emit(InvoiceDetailSuccess(detail)),
    );
  }

  Future<void> _onDownloadInvoice(
    DownloadInvoiceEvent event,
    Emitter<InvoiceDetailState> emit,
  ) async {
    // Keep the current detail visible during the download.
    final current = state;
    if (current is! InvoiceDetailSuccess &&
        current is! InvoiceDetailDownloaded) {
      // Cannot download without a successfully loaded detail.
      emit(const InvoiceDetailError(
        'Please load the invoice detail before downloading.',
      ));
      return;
    }

    final currentDetail = current is InvoiceDetailSuccess
        ? current.detail
        : (current as InvoiceDetailDownloaded).detail;

    emit(InvoiceDetailDownloading(currentDetail));

    final result = await downloadInvoiceUseCase(
      DownloadInvoiceParams(invoiceId: event.invoiceId),
    );

    result.fold(
      (failure) => emit(InvoiceDetailError(failure.message)),
      (_) => emit(InvoiceDetailDownloaded(currentDetail)),
    );
  }
}
