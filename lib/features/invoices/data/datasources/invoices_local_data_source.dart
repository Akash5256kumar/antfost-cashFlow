import '../../../../core/errors/exceptions.dart';
import '../models/invoice_model.dart';

/// Contract for the local invoices data source (cache layer).
abstract class InvoicesLocalDataSource {
  /// Returns the cached list of invoices.
  /// Throws [CacheException] if no cached data exists.
  Future<List<InvoiceModel>> getCachedInvoices();

  /// Stores [invoices] in the in-memory cache.
  Future<void> cacheInvoices(List<InvoiceModel> invoices);

  /// Returns the cached [InvoiceDetailModel] for [invoiceId].
  /// Throws [CacheException] if no cached data exists for that id.
  Future<InvoiceDetailModel> getCachedInvoiceDetail(String invoiceId);

  /// Stores [detail] in the in-memory cache keyed by its id.
  Future<void> cacheInvoiceDetail(InvoiceDetailModel detail);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Hive/SharedPreferences when wired.
// ---------------------------------------------------------------------------

/// In-memory mock local data source. Data is lost when the app restarts.
class MockInvoicesLocalDataSource implements InvoicesLocalDataSource {
  List<InvoiceModel>? _cachedInvoices;
  final Map<String, InvoiceDetailModel> _cachedDetails = {};

  @override
  Future<List<InvoiceModel>> getCachedInvoices() async {
    final invoices = _cachedInvoices;
    if (invoices == null) {
      throw const CacheException('No cached invoices found.');
    }
    return invoices;
  }

  @override
  Future<void> cacheInvoices(List<InvoiceModel> invoices) async {
    _cachedInvoices = invoices;
  }

  @override
  Future<InvoiceDetailModel> getCachedInvoiceDetail(String invoiceId) async {
    final detail = _cachedDetails[invoiceId];
    if (detail == null) {
      throw CacheException('No cached detail for invoice $invoiceId.');
    }
    return detail;
  }

  @override
  Future<void> cacheInvoiceDetail(InvoiceDetailModel detail) async {
    _cachedDetails[detail.id] = detail;
  }
}
