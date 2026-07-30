import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_detail.dart';
import '../repositories/invoices_repository.dart';

/// Retrieves the full detail of a single invoice.
class GetInvoiceDetailUseCase extends UseCase<InvoiceDetail, GetInvoiceDetailParams> {
  final InvoicesRepository repository;

  const GetInvoiceDetailUseCase(this.repository);

  @override
  Future<Either<Failure, InvoiceDetail>> call(GetInvoiceDetailParams params) {
    if (params.invoiceId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Invoice ID is required.')),
      );
    }
    return repository.getInvoiceDetail(params.invoiceId.trim());
  }
}

/// Parameters for [GetInvoiceDetailUseCase].
class GetInvoiceDetailParams extends Equatable {
  final String invoiceId;

  const GetInvoiceDetailParams({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}
