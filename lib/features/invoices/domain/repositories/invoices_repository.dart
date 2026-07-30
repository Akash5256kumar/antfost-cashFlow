import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/invoice.dart';
import '../entities/invoice_detail.dart';

/// Contract that the data layer must fulfil for invoice operations.
/// All methods return [Either] so callers handle failures explicitly.
abstract class InvoicesRepository {
  /// Returns the full list of invoices for the authenticated user.
  Future<Either<Failure, List<Invoice>>> getInvoices();

  /// Returns the detailed view of the invoice identified by [invoiceId].
  Future<Either<Failure, InvoiceDetail>> getInvoiceDetail(String invoiceId);

  /// Triggers a download for the invoice identified by [invoiceId].
  /// Returns `true` on success.
  Future<Either<Failure, bool>> downloadInvoice(String invoiceId);
}
