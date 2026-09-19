import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/utils/route_feedback.dart';
import 'price_breakdown_screen.dart';
import '../../app/di/injection.dart';
import '../../core/services/payment_api_service.dart';

enum _PayMethodId { wallet, card, bank, cash }

class _PayMethodSpec {
  const _PayMethodSpec({
    required this.id,
    required this.label,
    this.desc,
    this.imageUrl,
    this.available = true,
    this.total,
  });
  final _PayMethodId id;
  final String label;
  final String? desc;
  final String? imageUrl;
  final bool available;
  final double? total;
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.totalAmount,
    this.orderId,
    this.orderRef = 'AF-2057',
    this.quantity = 120,
    this.mixCode,
    this.projectName,
  });

  final double totalAmount;
  final String? orderId;
  final String orderRef;
  final int quantity;
  final String? mixCode;
  final String? projectName;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PayMethodId _selected = _PayMethodId.card;
  bool _loadingMethods = true;
  String? _paymentBlockedMessage;
  List<_PayMethodSpec> _methods = const [];

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  Future<void> _loadMethods() async {
    if (widget.orderId == null || widget.orderId!.isEmpty) {
      setState(() => _loadingMethods = false);
      return;
    }
    try {
      final data = await sl<PaymentApiService>().methods(
        orderId: widget.orderId!,
      );
      final items = (data['items'] as List)
          .whereType<Map>()
          .map(Map<String, dynamic>.from)
          .map(_methodFromApi)
          .whereType<_PayMethodSpec>()
          .toList();
      final blocked = data['blocked'];
      if (!mounted) return;
      setState(() {
        _methods = items;
        _paymentBlockedMessage = data['canPay'] == false && blocked is Map
            ? blocked['message'] as String? ??
                  'Complete verification before payment.'
            : null;
        final firstAvailable = items
            .where((item) => item.available)
            .firstOrNull;
        if (firstAvailable != null &&
            !items.any((item) => item.id == _selected && item.available)) {
          _selected = firstAvailable.id;
        }
        _loadingMethods = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingMethods = false);
      _showError(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  _PayMethodSpec? _methodFromApi(Map<String, dynamic> item) {
    final id = switch (item['id']) {
      'wallet' => _PayMethodId.wallet,
      'card' => _PayMethodId.card,
      'bankTransfer' => _PayMethodId.bank,
      'cash' => _PayMethodId.cash,
      _ => null,
    };
    if (id == null) return null;
    final balance = item['balance'];
    final balanceText = balance is Map && balance['availableBalance'] is num
        ? 'AED ${(balance['availableBalance'] as num).toStringAsFixed(2)} available'
        : null;
    final total = (item['total'] as num?)?.toDouble();
    final currency = item['currency'] as String? ?? 'AED';
    final totalText = total == null
        ? null
        : '$currency ${total.toStringAsFixed(2)} total';
    return _PayMethodSpec(
      id: id,
      label: item['title'] as String? ?? _labelFor(id),
      desc: item['available'] == false
          ? item['unavailableReason'] as String?
          : [balanceText, totalText].whereType<String>().join(' • '),
      imageUrl: item['imageUrl'] as String?,
      available: item['available'] != false,
      total: total,
    );
  }

  String _labelFor(_PayMethodId id) => switch (id) {
    _PayMethodId.wallet => 'Wallet',
    _PayMethodId.card => 'Card / Payment Link',
    _PayMethodId.bank => 'Bank Transfer',
    _PayMethodId.cash => 'Cash in Advance',
  };

  String _fallbackImageFor(_PayMethodId id) => switch (id) {
    _PayMethodId.wallet => AppAssets.artWalletMini,
    _PayMethodId.card => AppAssets.artCardMini,
    _PayMethodId.bank => AppAssets.artBankMini,
    _PayMethodId.cash => AppAssets.artCashMini,
  };

  _PayMethodSpec? get _selectedMethod =>
      _methods.where((method) => method.id == _selected).firstOrNull;

  Future<void> _continue() async {
    if (_paymentBlockedMessage != null) {
      _showBlockedDialog(_paymentBlockedMessage!);
      return;
    }
    final method = switch (_selected) {
      _PayMethodId.card => 'card',
      _PayMethodId.wallet => 'wallet',
      _PayMethodId.bank => 'bankTransfer',
      _PayMethodId.cash => 'cash',
    };
    final selectedTotal = _selectedMethod?.total ?? widget.totalAmount;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PriceBreakdownScreen(
          orderId: widget.orderId,
          projectName: widget.projectName ?? 'Palm Jumeirah Villa',
          mixCode: widget.mixCode ?? 'C30/37',
          quantity: widget.quantity,
          totalAmount: selectedTotal,
          paymentMethod: method,
        ),
      ),
    );
  }

  void _showError(String message) => showAppSnackBar(context, message);

  void _showBlockedDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(20)),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(context.scaled(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(context.scaled(12)),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: context.scaled(32),
                  color: const Color(0xFFEF4444),
                ),
              ),
              SizedBox(height: context.scaledV(16)),
              Text(
                'Verification Required',
                style: TextStyle(
                  fontSize: context.scaled(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: context.scaledV(12)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: context.scaledV(12)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(12),
                  vertical: context.scaledV(8),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(context.scaled(8)),
                ),
                child: Text(
                  'Don\'t worry, your current order has been safely saved to your Drafts.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.scaled(13),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ),
              SizedBox(height: context.scaledV(24)),
              PrimaryButton(
                label: 'Go to Home',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: context.scaledV(12)),
              AppOutlineButton(
                label: 'Go Back',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppBrandHeader(showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.scaled(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.scaledV(24)),
                    Text(
                      'Choose Payment Method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.scaled(20),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1B4B),
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(12),
                          vertical: context.scaledV(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(
                            context.scaled(16),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: context.scaled(14),
                              color: const Color(0xFF8B5CF6),
                            ),
                            SizedBox(width: context.scaled(6)),
                            Text(
                              '${widget.orderRef} • ${widget.quantity} m³',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),

                    if (_loadingMethods)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ..._methods.map((m) {
                        final isSelected = m.id == _selected;
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.scaledV(16)),
                          child: GestureDetector(
                            onTap: m.available
                                ? () => setState(() => _selected = m.id)
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.scaled(16),
                                vertical: context.scaledV(12),
                              ),
                              decoration: BoxDecoration(
                                color: isSelected && m.available
                                    ? const Color(0xFFF5F7FF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  context.scaled(16),
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFE2E8F0),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  m.imageUrl != null &&
                                          m.imageUrl!.startsWith('http')
                                      ? Image.network(
                                          m.imageUrl!,
                                          width: context.scaled(64),
                                          height: context.scaled(64),
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
                                                _fallbackImageFor(m.id),
                                                width: context.scaled(64),
                                                height: context.scaled(64),
                                              ),
                                        )
                                      : Image.asset(
                                          _fallbackImageFor(m.id),
                                          width: context.scaled(64),
                                          height: context.scaled(64),
                                          fit: BoxFit.contain,
                                        ),
                                  SizedBox(width: context.scaled(16)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.label,
                                          style: TextStyle(
                                            fontSize: context.scaled(15),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1F2533),
                                          ),
                                        ),
                                        if (m.desc != null) ...[
                                          SizedBox(height: context.scaledV(4)),
                                          Text(
                                            m.desc!,
                                            style: TextStyle(
                                              fontSize: context.scaled(11),
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: context.scaled(20),
                                    height: context.scaled(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected && m.available
                                            ? AppColors.primary
                                            : const Color(0xFFCBD5E1),
                                        width: isSelected ? 5.0 : 1.0,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                    SizedBox(height: context.scaledV(16)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.scaled(4)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_user_outlined,
                            size: context.scaled(14),
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                        SizedBox(width: context.scaled(12)),
                        Expanded(
                          child: Text(
                            'Your selected method determines the final charges shown next.',
                            style: TextStyle(
                              fontSize: context.scaled(12),
                              color: const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(32)),

                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, // Removed horizontal padding since scroll view has it
                        context.scaled(16),
                        0,
                        MediaQuery.paddingOf(context).bottom +
                            context.scaled(16),
                      ),
                      // Removed top border since it's no longer pinned
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton(
                            label: 'Continue to Price Breakdown',
                            arrow: true,
                            onPressed: _loadingMethods || _methods.isEmpty
                                ? null
                                : _continue,
                          ),
                          SizedBox(height: context.scaledV(12)),
                          AppOutlineButton(
                            label: 'Back to Order Review',
                            onPressed: () => Navigator.of(
                              context,
                            ).pop(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
