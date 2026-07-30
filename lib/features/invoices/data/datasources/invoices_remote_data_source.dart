import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/invoice.dart';
import '../models/invoice_model.dart';

/// Contract for the remote invoices data source.
abstract class InvoicesRemoteDataSource {
  /// Returns a list of [InvoiceModel] from the remote API.
  /// Throws [ServerException] on failure.
  Future<List<InvoiceModel>> getInvoices();

  /// Returns an [InvoiceDetailModel] for [invoiceId].
  /// Throws [ServerException] on failure.
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId);

  /// Triggers a download for [invoiceId].
  /// Returns `true` on success. Throws [ServerException] on failure.
  Future<bool> downloadInvoice(String invoiceId);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Dio/Retrofit once the API is ready.
// ---------------------------------------------------------------------------

/// Simulates a 300 ms network round-trip.
Future<void> _fakeDelay() =>
    Future.delayed(const Duration(milliseconds: 300));

/// Simulates a slower 500 ms download delay.
Future<void> _fakeDownloadDelay() =>
    Future.delayed(const Duration(milliseconds: 500));

/// Mock remote data source for development / testing purposes.
class MockInvoicesRemoteDataSource implements InvoicesRemoteDataSource {
  @override
  Future<List<InvoiceModel>> getInvoices() async {
    await _fakeDelay();
    return const [
      InvoiceModel(
        id: 'INV-2026-02-00001',
        orderId: 'ord-001',
        totalAmount: 22785.00,
        date: '9 Feb 2026',
        types: [InvoiceType.vat],
        status: InvoiceStatus.paid,
      ),
      InvoiceModel(
        id: 'INV-2026-02-00002',
        orderId: 'ord-002',
        totalAmount: 15120.00,
        date: '8 Feb 2026',
        types: [],
        status: InvoiceStatus.vatInvoiceReady,
      ),
      InvoiceModel(
        id: 'INV-2026-02-00003',
        orderId: 'ord-003',
        totalAmount: 53760.00,
        date: '7 Feb 2026',
        types: [InvoiceType.vat],
        status: InvoiceStatus.sent,
      ),
      InvoiceModel(
        id: 'INV-2026-02-00004',
        orderId: 'ord-004',
        totalAmount: 7087.50,
        date: '9 Feb 2026',
        types: [InvoiceType.vat],
        status: InvoiceStatus.draft,
      ),
      InvoiceModel(
        id: 'INV-2026-02-00005',
        orderId: 'ord-005',
        totalAmount: 22785.00,
        date: '5 Feb 2026',
        types: [InvoiceType.vat],
        status: InvoiceStatus.paid,
      ),
    ];
  }

  @override
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId) async {
    await _fakeDelay();
    return InvoiceDetailModel(
      id: invoiceId,
      orderId: 'ord-001',
      totalAmount: 22785.00,
      date: '9 Feb 2026',
      types: const [InvoiceType.vat],
      status: InvoiceStatus.paid,
      customerName: 'Omar Construction LLC',
      customerAddress: 'Dubai Marina, Dubai, UAE',
      vatNumber: 'TRN100123456789',
      lineItems: const [
        InvoiceLineItemModel(
          description: 'Ready-Mix Concrete C25/30',
          quantity: 50.0,
          unitPrice: 450.0,
          total: 22500.0,
        ),
        InvoiceLineItemModel(
          description: 'Delivery Charge',
          quantity: 1.0,
          unitPrice: 250.0,
          total: 250.0,
        ),
        InvoiceLineItemModel(
          description: 'VAT (5%)',
          quantity: 1.0,
          unitPrice: 35.0,
          total: 35.0,
        ),
      ],
    );
  }

  @override
  Future<bool> downloadInvoice(String invoiceId) async {
    await _fakeDownloadDelay();
    return true;
  }
}
