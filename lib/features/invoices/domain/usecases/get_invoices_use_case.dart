import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice.dart';
import '../repositories/invoices_repository.dart';

/// Retrieves the list of all invoices for the authenticated user.
class GetInvoicesUseCase extends UseCase<List<Invoice>, NoParams> {
  final InvoicesRepository repository;

  const GetInvoicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Invoice>>> call(NoParams params) {
    return repository.getInvoices();
  }
}
