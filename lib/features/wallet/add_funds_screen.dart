import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import 'presentation/bloc/wallet_bloc.dart';
import 'presentation/bloc/wallet_event.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _labelGrey = Color(0xFF9F9DA6);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg = Color(0xFFF2F2F7);

// ── Funding method enum ───────────────────────────────────────────────────────
enum _FundMethod { card, bankTransfer }

// ── Quick amounts ─────────────────────────────────────────────────────────────
const _quickAmounts = [500.0, 1000.0, 2500.0, 5000.0];

// ── Screen ────────────────────────────────────────────────────────────────────

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  _FundMethod _method = _FundMethod.card;
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double? _selectedQuick;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectQuick(double amount) {
    setState(() {
      _selectedQuick = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  String _fmtAmount(double v) {
    final i = v.truncate();
    final f = ((v - i) * 100).round();
    final s = i.toString();
    final buf = StringBuffer();
    for (var k = 0; k < s.length; k++) {
      if (k > 0 && (s.length - k) % 3 == 0) buf.write(',');
      buf.write(s[k]);
    }
    if (f > 0) {
      buf.write('.');
      buf.write(f.toString().padLeft(2, '0'));
    }
    return buf.toString();
  }

  String get _displayAmount {
    final raw = double.tryParse(_amountController.text.trim());
    if (raw == null || raw <= 0) return 'AED 0.00';
    return 'AED ${_fmtAmount(raw)}';
  }

  void _confirm(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    ctx.read<WalletBloc>().add(AddFundsEvent(amount));
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── App bar ───────────────────────────────────────────────
              _AddFundsAppBar(amountLabel: _displayAmount),

              // ── Body ──────────────────────────────────────────────────
              Expanded(
                child: ColoredBox(
                  color: _bodyBg,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      context.scaled(16),
                      context.scaledV(20),
                      context.scaled(16),
                      context.scaledV(28),
                    ),
                    child: StatefulBuilder(
                      builder: (context, innerSetState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Amount entry card ──────────────────────
                            _SectionLabel(label: 'Enter Amount'),
                            SizedBox(height: context.scaledV(10)),
                            _AmountCard(
                              controller: _amountController,
                              selectedQuick: _selectedQuick,
                              onQuickTap: (v) {
                                _selectQuick(v);
                                innerSetState(() {});
                                setState(() {});
                              },
                              onChanged: (v) {
                                final parsed = double.tryParse(v);
                                innerSetState(() {
                                  _selectedQuick = (parsed != null &&
                                          _quickAmounts.contains(parsed))
                                      ? parsed
                                      : null;
                                });
                                setState(() {});
                              },
                            ),
                            SizedBox(height: context.scaledV(20)),

                            // ── Payment method ─────────────────────────
                            _SectionLabel(label: 'Payment Method'),
                            SizedBox(height: context.scaledV(10)),
                            _MethodTile(
                              icon: Icons.credit_card_rounded,
                              label: 'Card Payment',
                              subtitle: 'Credit or debit card (instant)',
                              badge: 'Instant',
                              badgeBg: AppColors.successContainer,
                              badgeFg: AppColors.success,
                              selected: _method == _FundMethod.card,
                              onTap: () =>
                                  setState(() => _method = _FundMethod.card),
                            ),
                            SizedBox(height: context.scaledV(10)),
                            _MethodTile(
                              icon: Icons.account_balance_rounded,
                              label: 'Bank Transfer',
                              subtitle:
                                  'Receive a payment link via SMS/email',
                              badge: '1–2 days',
                              badgeBg: AppColors.warningContainer,
                              badgeFg: AppColors.warning,
                              selected: _method == _FundMethod.bankTransfer,
                              onTap: () => setState(
                                  () => _method = _FundMethod.bankTransfer),
                            ),
                            SizedBox(height: context.scaledV(20)),

                            // ── Card form / Bank info ──────────────────
                            if (_method == _FundMethod.card) ...[
                              _SectionLabel(label: 'Card Details'),
                              SizedBox(height: context.scaledV(10)),
                              _CardForm(),
                            ],
                            if (_method == _FundMethod.bankTransfer) ...[
                              _BankTransferInfo(),
                            ],

                            SizedBox(height: context.scaledV(16)),

                            // ── Security note ──────────────────────────
                            _SecurityNote(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ── Bottom bar ────────────────────────────────────────────
              _BottomBar(
                amountLabel: _displayAmount,
                onConfirm: () => _confirm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ── App bar ───────────────────────────────────────────────────────────────────

class _AddFundsAppBar extends StatelessWidget {
  const _AddFundsAppBar({required this.amountLabel});
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaledV(8),
        context.scaled(16),
        context.scaledV(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.scaled(44),
            height: context.scaled(44),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(24)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          SizedBox(width: context.scaled(4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Funds',
                style: TextStyle(
                  fontSize: context.scaled(20),
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              Text(
                amountLabel,
                style: TextStyle(
                  fontSize: context.scaled(14),
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

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: context.scaled(14),
        fontWeight: FontWeight.w600,
        color: _textDark,
        height: 1.3,
      ),
    );
  }
}

// ── Amount card ───────────────────────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.selectedQuick,
    required this.onQuickTap,
    required this.onChanged,
  });

  final TextEditingController controller;
  final double? selectedQuick;
  final ValueChanged<double> onQuickTap;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: [
          // Amount input
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(16),
              vertical: context.scaledV(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'AED',
                  style: TextStyle(
                    fontSize: context.scaled(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
                SizedBox(width: context.scaled(12)),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    style: TextStyle(
                      fontSize: context.scaled(32),
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        fontSize: context.scaled(32),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFCCCCCC),
                        height: 1.2,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount';
                      }
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Amount must be greater than zero';
                      }
                      if (parsed < 100) {
                        return 'Minimum top-up is AED 100';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(color: _fieldBorder, height: 1),

          // Quick amounts
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(12),
              vertical: context.scaledV(12),
            ),
            child: Row(
              children: _quickAmounts.map((amount) {
                final isSelected = selectedQuick == amount;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scaled(4)),
                    child: GestureDetector(
                      onTap: () => onQuickTap(amount),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          vertical: context.scaledV(8),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : const Color(0xFFF4F4F7),
                          borderRadius: BorderRadius.circular(context.scaled(10)),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${amount >= 1000 ? '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K' : amount.toInt()}',
                          style: TextStyle(
                            fontSize: context.scaled(13),
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.primary : _textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Validation error (if any)
        ],
      ),
    );
  }
}

// ── Method tile ───────────────────────────────────────────────────────────────

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.badge,
    required this.badgeBg,
    required this.badgeFg,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final String badge;
  final Color badgeBg;
  final Color badgeFg;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer : Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: context.scaledV(76),
          padding: EdgeInsets.symmetric(horizontal: context.scaled(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.scaled(16)),
            border: Border.all(
              color: selected ? AppColors.primary : _fieldBorder,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width: context.scaled(44),
                height: context.scaled(44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryContainer
                      : const Color(0xFFF4F4F7),
                  borderRadius: BorderRadius.circular(context.scaled(12)),
                ),
                child: Icon(
                  icon,
                  size: context.scaled(22),
                  color: selected ? AppColors.primary : _labelGrey,
                ),
              ),
              SizedBox(width: context.scaled(12)),

              // Label + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: context.scaledV(3)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: context.scaled(12.5),
                        fontWeight: FontWeight.w400,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.scaled(8)),

              // Badge + radio
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaled(8),
                      vertical: context.scaledV(3),
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(context.scaled(20)),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: context.scaled(10.5),
                        fontWeight: FontWeight.w600,
                        color: badgeFg,
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(6)),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: context.scaled(20),
                    height: context.scaled(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? AppColors.primary : _fieldBorder,
                        width: selected ? 5.5 : 1.5,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
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
          hint: '1234  5678  9012  3456',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          trailing: Icon(
            Icons.credit_card_rounded,
            size: context.scaled(22),
            color: _labelGrey,
          ),
        ),
        SizedBox(height: context.scaledV(10)),
        _CardField(
          label: 'Cardholder Name',
          hint: 'Name on card',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: context.scaledV(10)),
        Row(
          children: [
            Expanded(
              child: _CardField(
                label: 'Expiry Date',
                hint: 'MM / YY',
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: context.scaled(10)),
            Expanded(
              child: _CardField(
                label: 'CVV',
                hint: '•••',
                keyboardType: TextInputType.number,
                obscure: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
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
    required this.hint,
    this.trailing,
    this.obscure = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final String hint;
  final Widget? trailing;
  final bool obscure;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.scaledV(72),
      padding: EdgeInsets.symmetric(horizontal: context.scaled(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
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
                  style: TextStyle(
                    fontSize: context.scaled(11.5),
                    fontWeight: FontWeight.w400,
                    color: _labelGrey,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: context.scaledV(4)),
                TextField(
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: TextStyle(
                    fontSize: context.scaled(15),
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                    height: 1.25,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: context.scaled(15),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFCCCCCC),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(
              context.scaled(16),
              context.scaledV(16),
              context.scaled(16),
              context.scaledV(14),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.scaled(16)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: context.scaled(36),
                  height: context.scaled(36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(context.scaled(10)),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: context.scaled(20),
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: context.scaled(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Transfer',
                        style: TextStyle(
                          fontSize: context.scaled(15),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        'Funds arrive in 1–2 business days',
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          color: AppColors.primary.withValues(alpha: 0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Info rows
          Padding(
            padding: EdgeInsets.all(context.scaled(16)),
            child: Column(
              children: [
                _BankRow(label: 'Bank Name', value: 'Emirates NBD'),
                SizedBox(height: context.scaledV(12)),
                _BankRow(label: 'Account Name', value: 'Antfost FZE LLC'),
                SizedBox(height: context.scaledV(12)),
                _BankRow(label: 'IBAN', value: 'AE070331234567890123456'),
                SizedBox(height: context.scaledV(12)),
                _BankRow(label: 'SWIFT / BIC', value: 'EBILAEAD'),
                SizedBox(height: context.scaledV(16)),

                // Note
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.scaled(12)),
                  decoration: BoxDecoration(
                    color: AppColors.warningContainer,
                    borderRadius: BorderRadius.circular(context.scaled(10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: context.scaled(16),
                        color: AppColors.warning,
                      ),
                      SizedBox(width: context.scaled(8)),
                      Expanded(
                        child: Text(
                          'Include your Company ID as payment reference so we can match your transfer.',
                          style: TextStyle(
                            fontSize: context.scaled(12.5),
                            color: AppColors.warning,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.scaled(110),
          child: Text(
            label,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: _textGrey,
              height: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: context.scaled(13.5),
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.4,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Clipboard.setData(ClipboardData(text: value)),
          child: Icon(
            Icons.copy_rounded,
            size: context.scaled(16),
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// ── Security note ─────────────────────────────────────────────────────────────

class _SecurityNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: context.scaled(13),
          color: _textGrey,
        ),
        SizedBox(width: context.scaled(5)),
        Text(
          'Secured by 256-bit SSL encryption',
          style: TextStyle(
            fontSize: context.scaled(12),
            color: _textGrey,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.amountLabel,
    required this.onConfirm,
  });

  final String amountLabel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(
          context.scaled(16),
          context.scaledV(12),
          context.scaled(16),
          context.scaledV(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DashedDivider(),
            SizedBox(height: context.scaledV(12)),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You are adding',
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        fontWeight: FontWeight.w500,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.scaledV(2)),
                    Text(
                      'Funds added to wallet instantly',
                      style: TextStyle(
                        fontSize: context.scaled(11.5),
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  amountLabel,
                  style: TextStyle(
                    fontSize: context.scaled(22),
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.scaledV(12)),
            SizedBox(
              width: double.infinity,
              height: context.scaledV(56),
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
                  borderRadius: BorderRadius.circular(context.scaled(18)),
                ),
                child: TextButton(
                  onPressed: onConfirm,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.scaled(18)),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: context.scaled(20),
                        color: Colors.white,
                      ),
                      SizedBox(width: context.scaled(8)),
                      Text(
                        'Confirm & Add Funds',
                        style: TextStyle(
                          fontSize: context.scaled(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            (_) => const Padding(
              padding: EdgeInsets.only(right: dashGap),
              child: SizedBox(
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
