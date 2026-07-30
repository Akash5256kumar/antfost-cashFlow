import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/invoices_repository.dart';

/// Triggers a download for a single invoice PDF.
class DownloadInvoiceUseCase extends UseCase<bool, DownloadInvoiceParams> {
  final InvoicesRepository repository;

  const DownloadInvoiceUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DownloadInvoiceParams params) {
    if (params.invoiceId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Invoice ID is required.')),
      );
    }
    return repository.downloadInvoice(params.invoiceId.trim());
  }
}

/// Parameters for [DownloadInvoiceUseCase].
class DownloadInvoiceParams extends Equatable {
  final String invoiceId;

  const DownloadInvoiceParams({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}
