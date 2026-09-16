import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';
import 'domain/entities/invoice.dart';
import 'domain/entities/invoice_detail.dart';
import 'presentation/bloc/invoice_detail_bloc.dart';
import 'presentation/bloc/invoice_detail_event.dart';
import 'presentation/bloc/invoice_detail_state.dart';
import 'qc_checkpoint_screen.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceDetailBloc>().add(
      FetchInvoiceDetailEvent(widget.invoice.id),
    );
  }

  Future<void> _openDownload(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted)
        _showMessage('Unable to open the invoice download.', error: true);
    }
  }

  void _showMessage(String message, {bool error = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: error ? AppColors.error : AppColors.primary,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: context.scaled(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              widget.invoice.id,
              style: TextStyle(
                fontSize: context.scaled(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<InvoiceDetailBloc, InvoiceDetailState>(
        listener: (context, state) {
          if (state is InvoiceDetailDownloaded) {
            _openDownload(state.downloadUrl);
          } else if (state is InvoiceDetailError) {
            _showMessage(state.message, error: true);
          }
        },
        builder: (context, state) {
          if (state is InvoiceDetailInitial || state is InvoiceDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InvoiceDetailError) return _errorState(state.message);
          final detail = switch (state) {
            InvoiceDetailSuccess(:final detail) => detail,
            InvoiceDetailDownloading(:final detail) => detail,
            InvoiceDetailDownloaded(:final detail) => detail,
            _ => null,
          };
          if (detail == null) return const SizedBox.shrink();
          return _content(
            detail,
            downloading: state is InvoiceDetailDownloading,
          );
        },
      ),
    );
  }

  Widget _errorState(String message) => Center(
    child: Padding(
      padding: EdgeInsets.all(context.scaled(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.read<InvoiceDetailBloc>().add(
              FetchInvoiceDetailEvent(widget.invoice.id),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    ),
  );

  Widget _content(InvoiceDetail detail, {required bool downloading}) {
    final lineTotal = detail.lineItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    final inferredDifference = detail.totalAmount - lineTotal;
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.scaled(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order ID: ${detail.orderId}',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _status(detail.status),
                  ],
                ),
                SizedBox(height: context.scaledV(12)),
                _labelValue('Issue date', _formatDate(detail.date)),
                SizedBox(height: context.scaledV(10)),
                _labelValue(
                  'Invoice total',
                  _money(detail.totalAmount),
                  emphasis: true,
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaledV(14)),
          Text('Customer Information', style: _sectionStyle),
          SizedBox(height: context.scaledV(8)),
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.business_outlined, detail.customerName),
                if (detail.customerAddress.isNotEmpty) ...[
                  SizedBox(height: context.scaledV(10)),
                  _infoRow(Icons.location_on_outlined, detail.customerAddress),
                ],
                if (detail.vatNumber.isNotEmpty) ...[
                  SizedBox(height: context.scaledV(10)),
                  _infoRow(Icons.receipt_outlined, 'VAT: ${detail.vatNumber}'),
                ],
              ],
            ),
          ),
          SizedBox(height: context.scaledV(14)),
          Text('Line Items', style: _sectionStyle),
          SizedBox(height: context.scaledV(8)),
          _lineItems(detail.lineItems),
          SizedBox(height: context.scaledV(14)),
          Text('Amount Breakdown', style: _sectionStyle),
          SizedBox(height: context.scaledV(8)),
          _card(
            Column(
              children: [
                _amountRow('Line items total', _money(lineTotal)),
                if (inferredDifference.abs() > 0.009) ...[
                  SizedBox(height: context.scaledV(10)),
                  _amountRow('Adjustment / tax', _money(inferredDifference)),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.scaledV(12)),
                  child: const Divider(height: 1),
                ),
                _amountRow(
                  'Total amount',
                  _money(detail.totalAmount),
                  emphasis: true,
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaledV(24)),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QcCheckpointScreen(orderId: detail.orderId),
              ),
            ),
            icon: const Icon(Icons.verified_outlined),
            label: const Text('View Quality Check'),
          ),
          SizedBox(height: context.scaledV(12)),
          PrimaryButton(
            label: downloading ? 'Preparing download…' : 'Download Invoice',
            onPressed: downloading
                ? null
                : () => context.read<InvoiceDetailBloc>().add(
                    DownloadInvoiceEvent(detail.id),
                  ),
            icon: const Icon(Icons.download_rounded, color: Colors.white),
          ),
          SizedBox(height: context.scaledV(20)),
        ],
      ),
    );
  }

  TextStyle get _sectionStyle => TextStyle(
    fontSize: context.scaled(16),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  Widget _card(Widget child) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(context.scaled(16)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(16)),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: child,
  );
  Widget _labelValue(String label, String value, {bool emphasis = false}) =>
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.scaled(13),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.scaled(emphasis ? 17 : 14),
              fontWeight: emphasis ? FontWeight.w700 : FontWeight.w600,
              color: emphasis ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      );
  Widget _infoRow(IconData icon, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: context.scaled(18), color: AppColors.textSecondary),
      SizedBox(width: context.scaled(10)),
      Expanded(
        child: Text(
          value.isEmpty ? '—' : value,
          style: TextStyle(
            fontSize: context.scaled(14),
            color: AppColors.textPrimary,
          ),
        ),
      ),
    ],
  );
  Widget _amountRow(String label, String value, {bool emphasis = false}) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(emphasis ? 15 : 14),
            fontWeight: emphasis ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: context.scaled(emphasis ? 17 : 14),
          fontWeight: emphasis ? FontWeight.w700 : FontWeight.w600,
          color: emphasis ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    ],
  );

  Widget _lineItems(List<InvoiceLineItem> items) {
    if (items.isEmpty)
      return _card(
        const Text(
          'No line items were returned for this invoice.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    return _card(
      Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    items[index].description,
                    style: TextStyle(
                      fontSize: context.scaled(14),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _quantity(items[index].quantity),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.scaled(13),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _money(items[index].total),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: context.scaled(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (index != items.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.scaledV(12)),
                child: const Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }

  Widget _status(InvoiceStatus status) {
    final label = switch (status) {
      InvoiceStatus.paid => 'Paid',
      InvoiceStatus.vatInvoiceReady => 'VAT ready',
      InvoiceStatus.sent => 'Sent',
      InvoiceStatus.draft => 'Draft',
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(9),
        vertical: context.scaledV(5),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.scaled(12),
          fontWeight: FontWeight.w600,
          color: AppColors.success,
        ),
      ),
    );
  }

  String _money(double value) => 'AED ${value.toStringAsFixed(2)}';
  String _quantity(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value.isEmpty ? '—' : value;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
  }
}
