import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'transaction_history_screen.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);

// ── Screen ────────────────────────────────────────────────────────────────────

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Token m³ balance and transactions',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Balance card
                    _BalanceCard(),
                    const SizedBox(height: 14),

                    // Hint text
                    const Text(
                      'Use wallet balance to pay for orders instantly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Add Funds button
                    _AddFundsButton(),
                    const SizedBox(height: 8),

                    const Text(
                      'Add funds via Card or Payment Link (Bank Transfer).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick tiles
                    Row(
                      children: [
                        Expanded(
                          child: _QuickTile(
                            icon: Icons.arrow_forward_rounded,
                            label: 'Transaction\nHistory',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TransactionHistoryScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickTile(
                            icon: Icons.lock_outline_rounded,
                            label: 'Reserved Balance\nInfo',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Recent Transactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            height: 1.3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TransactionHistoryScreen(),
                            ),
                          ),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _TransactionList(),

                    const SizedBox(height: 20),
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

// ── Balance card ──────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Purple accent bar at top
          Container(
            height: 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Token m³',
                  style: TextStyle(fontSize: 13, color: _textGrey, height: 1.3),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  const TextSpan(
                    text: '854.5',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                    children: [
                      TextSpan(
                        text: ' m³',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: _textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Estimated value: AED 153,450',
                  style: TextStyle(fontSize: 14, color: _textGrey, height: 1.3),
                ),
                const SizedBox(height: 16),
                const Divider(color: _fieldBorder, height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Reserved Token m³',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textGrey,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '75.5 m³',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Token m³',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textGrey,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '930.0 m³',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add funds button ──────────────────────────────────────────────────────────

class _AddFundsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add Funds',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick tile ────────────────────────────────────────────────────────────────

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FB),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textDark,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent transactions ───────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      _TxData(
        icon: Icons.south_west_rounded,
        name: 'Wallet Deposit',
        amount: '+AED 41,250',
        status: 'Completed',
        statusColor: Color(0xFF16A34A),
        statusBg: Color(0xFFDCFCE7),
        amountColor: Color(0xFF16A34A),
      ),
      _TxData(
        icon: Icons.lock_outline_rounded,
        name: 'Order Payment Reserved',
        subtitle: 'AF-2026-02-000234',
        amount: 'AED 12,457.5',
        status: 'Reserved',
        statusColor: AppColors.primary,
        statusBg: Color(0xFFEDE9FB),
        amountColor: _textDark,
      ),
      _TxData(
        icon: Icons.north_east_rounded,
        name: 'Order Payment',
        subtitle: 'AF-2026-02-000233',
        amount: '-AED 24,750',
        status: 'Completed',
        statusColor: Color(0xFF16A34A),
        statusBg: Color(0xFFDCFCE7),
        amountColor: Color(0xFFEF4444),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              _TransactionRow(data: items[i]),
              if (i < items.length - 1)
                const Divider(
                  color: _fieldBorder,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _TxData {
  const _TxData({
    required this.icon,
    required this.name,
    this.subtitle,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.amountColor,
  });

  final IconData icon;
  final String name;
  final String? subtitle;
  final String amount;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final Color amountColor;
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.data});
  final _TxData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEDE9FB),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
                if (data.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _textGrey,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: data.amountColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: data.statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: data.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav bar ────────────────────────────────────────────────────────────
