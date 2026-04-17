import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'payment_success_screen.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark    = Color(0xFF1A1A1A);
const Color _textGrey    = Color(0xFF9E9E9E);
const Color _labelGrey   = Color(0xFF9F9DA6);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg      = Color(0xFFF2F2F7);

// ── Payment method enum ───────────────────────────────────────────────────────
enum _PayMethod { card, bankTransfer, wallet }

// ── Screen ────────────────────────────────────────────────────────────────────

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.totalAmount});
  final double totalAmount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PayMethod _method = _PayMethod.card;

  static const double _walletBalance = 23150;
  static const String _referenceCode = 'CO-83335097';

  double get _payAmount =>
      (_method == _PayMethod.wallet && _walletBalance >= widget.totalAmount)
          ? 0
          : (_method == _PayMethod.wallet)
              ? widget.totalAmount - _walletBalance
              : 4882.50; // card / bank example

  String _fmtAmount(double v) {
    if (v == v.truncateToDouble()) {
      return 'AED ${_formatNum(v.toInt())}.00';
    }
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    return 'AED ${_formatNumStr(parts[0])}.${parts[1]}';
  }

  String _formatNum(int n) => _formatNumStr(n.toString());
  String _formatNumStr(String s) {
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────
            _PayAppBar(amountLabel: _fmtAmount(4882.50)),

            // ── Body ──────────────────────────────────────────────────
            Expanded(
              child: ColoredBox(
                color: _bodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment method tiles
                      _PayMethodTile(
                        icon: Icons.credit_card_rounded,
                        label: 'Card Payment',
                        subtitle: 'Pay with credit or debit card',
                        selected: _method == _PayMethod.card,
                        onTap: () =>
                            setState(() => _method = _PayMethod.card),
                      ),
                      const SizedBox(height: 10),
                      _PayMethodTile(
                        icon: Icons.account_balance_rounded,
                        label: 'Payment Link (Bank Transfer)',
                        subtitle: 'Transfer via bank with reference code',
                        selected: _method == _PayMethod.bankTransfer,
                        onTap: () =>
                            setState(() => _method = _PayMethod.bankTransfer),
                      ),
                      const SizedBox(height: 10),
                      _PayMethodTile(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'Wallet Balance',
                        subtitle:
                            'Available: ${_fmtAmount(_walletBalance)}',
                        selected: _method == _PayMethod.wallet,
                        onTap: () =>
                            setState(() => _method = _PayMethod.wallet),
                      ),
                      const SizedBox(height: 20),

                      // Card Payment
                      if (_method == _PayMethod.card) ...[
                        const Text(
                          'Card Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _CardForm(),
                      ],

                      // Bank Transfer
                      if (_method == _PayMethod.bankTransfer) ...[
                        const Text(
                          'Card Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _BankTransferInfo(reference: _referenceCode),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Total + Pay button ────────────────────────────────────
            _PayBottomBar(
              totalLabel: _fmtAmount(widget.totalAmount),
              payLabel: 'Pay ${_fmtAmount(4882.50)}',
              onPay: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Payment app bar ───────────────────────────────────────────────────────────

class _PayAppBar extends StatelessWidget {
  const _PayAppBar({required this.amountLabel});
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amountLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Payment method tile ───────────────────────────────────────────────────────

class _PayMethodTile extends StatelessWidget {
  const _PayMethodTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEDE9FB) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : _fieldBorder,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card form ─────────────────────────────────────────────────────────────────

class _CardForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CardField(
          label: 'Card Number',
          value: '1234 5678 9012 3456',
          trailing: const Icon(
            Icons.credit_card_rounded,
            size: 22,
            color: _labelGrey,
          ),
        ),
        const SizedBox(height: 10),
        _CardField(label: 'Cardholder Name', value: 'OMAR'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _CardField(label: 'Expiry Date', value: 'MM/YY'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CardField(
                label: 'CVV',
                value: '•••',
                obscure: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.label,
    required this.value,
    this.trailing,
    this.obscure = false,
  });

  final String label;
  final String value;
  final Widget? trailing;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _labelGrey,
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ── Bank transfer info ────────────────────────────────────────────────────────

class _BankTransferInfo extends StatelessWidget {
  const _BankTransferInfo({required this.reference});
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Transfer Instructions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You will receive a payment link via SMS/email with bank transfer details. Complete the transfer within 30 minutes to confirm your order.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _textDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reference',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              Text(
                reference,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pay bottom bar ────────────────────────────────────────────────────────────

class _PayBottomBar extends StatelessWidget {
  const _PayBottomBar({
    required this.totalLabel,
    required this.payLabel,
    required this.onPay,
  });

  final String totalLabel;
  final String payLabel;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DashedDivider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Includes 5% VAT',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  totalLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryGradientStart,
                      AppColors.primaryGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextButton(
                  onPressed: onPay,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    payLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline_rounded, size: 14, color: _textGrey),
                SizedBox(width: 5),
                Text(
                  'Secured by 256-bit SSL encryption',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textGrey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashed divider ────────────────────────────────────────────────────────────

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashW = 8.0;
        const dashGap = 5.0;
        final count = (constraints.maxWidth / (dashW + dashGap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: dashGap),
              child: const SizedBox(
                width: dashW,
                height: 1,
                child: ColoredBox(color: Color(0xFFDDDDDD)),
              ),
            ),
          ),
        );
      },
    );
  }
}
