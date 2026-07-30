import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import 'domain/entities/transaction.dart';
import 'domain/entities/wallet_balance.dart';
import 'presentation/bloc/wallet_bloc.dart';
import 'presentation/bloc/wallet_event.dart';
import 'presentation/bloc/wallet_state.dart';
import 'transaction_history_screen.dart';

// ── Colours ───────────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);

// ── Screen ────────────────────────────────────────────────────────────────────

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the initial wallet data fetch via BLoC.
    context.read<WalletBloc>().add(const FetchWalletDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.wallet),
      body: SafeArea(
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletFundsAdded) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(content: Text('Funds added successfully!')),
                );
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      context
                          .read<WalletBloc>()
                          .add(const RetryWalletEvent());
                    },
                  ),
                ));
            }
          },
          builder: (context, state) {
            final isAddingFunds = state is WalletAddingFunds;

            return Column(
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

                        // Balance card / shimmer
                        if (state is WalletLoading)
                          _buildBalanceShimmer()
                        else if (state is WalletSuccess)
                          _BalanceCard(balance: state.balance)
                        else if (state is WalletAddingFunds)
                          _buildBalanceShimmer()
                        else
                          _buildBalanceShimmer(),

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
                        _AddFundsButton(
                          isLoading: isAddingFunds,
                          onTap: () {
                            context
                                .read<WalletBloc>()
                                .add(const AddFundsEvent(0));
                          },
                        ),
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

                        // Recent Transactions header
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
                                  builder: (_) =>
                                      const TransactionHistoryScreen(),
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

                        // Transaction list / shimmer
                        if (state is WalletLoading || state is WalletAddingFunds)
                          _buildTransactionShimmer()
                        else if (state is WalletSuccess)
                          _TransactionList(transactions: state.transactions)
                        else
                          _buildTransactionShimmer(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Shimmer placeholder for the balance card while data is loading.
  Widget _buildBalanceShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Shimmer placeholder for the transaction list while data is loading.
  Widget _buildTransactionShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ── Balance card ──────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  /// Domain entity carrying the live wallet balance figures.
  final WalletBalance balance;

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
                  TextSpan(
                    text: balance.availableTokenM3.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                    children: const [
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
                Text(
                  'Estimated value: AED ${_formatAmount(balance.estimatedValueAed)}',
                  style: const TextStyle(
                      fontSize: 14, color: _textGrey, height: 1.3),
                ),
                const SizedBox(height: 16),
                const Divider(color: _fieldBorder, height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reserved Token m³',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textGrey,
                              height: 1.33,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${balance.reservedTokenM3.toStringAsFixed(1)} m³',
                            style: const TextStyle(
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
                        children: [
                          const Text(
                            'Total Token m³',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textGrey,
                              height: 1.33,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${balance.totalTokenM3.toStringAsFixed(1)} m³',
                            style: const TextStyle(
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
  const _AddFundsButton({
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;

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
          onPressed: isLoading ? null : onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
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
  const _TransactionList({required this.transactions});

  /// Full list of domain transactions. Only the first 3 are displayed here.
  final List<WalletTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    // Show only the first 3 recent transactions.
    final recent = transactions.take(3).toList();
    final items = recent.map(_toTxData).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

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

  /// Maps a [WalletTransaction] domain entity to the internal [_TxData] render
  /// model, keeping visual logic decoupled from the domain layer.
  static _TxData _toTxData(WalletTransaction tx) {
    // Determine display icon based on transaction type.
    final IconData icon;
    switch (tx.type) {
      case TransactionType.deposit:
      case TransactionType.refund:
        icon = Icons.south_west_rounded;
        break;
      case TransactionType.orderPayment:
      case TransactionType.reserved:
        icon = Icons.north_east_rounded;
        break;
    }

    // Format amount string with credit / debit sign.
    final amountStr =
        tx.isCredit ? '+AED ${_fmtAmount(tx.amount)}' : '-AED ${_fmtAmount(tx.amount)}';
    final amountColor =
        tx.isCredit ? const Color(0xFF16A34A) : const Color(0xFFEF4444);

    // Determine status badge colours.
    final (statusLabel, statusBg, statusColor) = switch (tx.status) {
      TransactionStatus.completed => (
        'Completed',
        const Color(0xFFDCFCE7),
        const Color(0xFF16A34A),
      ),
      TransactionStatus.reserved => (
        'Reserved',
        const Color(0xFFEDE9FB),
        AppColors.primary,
      ),
      TransactionStatus.pending => (
        'Pending',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
      TransactionStatus.failed => (
        'Failed',
        const Color(0xFFFFE4E4),
        const Color(0xFFEF4444),
      ),
    };

    return _TxData(
      icon: icon,
      name: tx.name,
      subtitle: tx.subtitle,
      amount: amountStr,
      status: statusLabel,
      statusColor: statusColor,
      statusBg: statusBg,
      amountColor: amountColor,
    );
  }

  /// Formats a numeric amount into a comma-separated string with 2 decimal places.
  static String _fmtAmount(double v) {
    final i = v.truncate();
    final f = ((v - i) * 100).round();
    final s = i.toString();
    final buf = StringBuffer();
    for (var k = 0; k < s.length; k++) {
      if (k > 0 && (s.length - k) % 3 == 0) buf.write(',');
      buf.write(s[k]);
    }
    buf.write('.');
    buf.write(f.toString().padLeft(2, '0'));
    return buf.toString();
  }
}

// ── Internal render model ─────────────────────────────────────────────────────

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

// ── Helper ────────────────────────────────────────────────────────────────────

/// Formats a numeric AED amount into a comma-separated string (e.g. 153,450.00).
String _formatAmount(double v) {
  final i = v.truncate();
  final f = ((v - i) * 100).round();
  final s = i.toString();
  final buf = StringBuffer();
  for (var k = 0; k < s.length; k++) {
    if (k > 0 && (s.length - k) % 3 == 0) buf.write(',');
    buf.write(s[k]);
  }
  buf.write('.');
  buf.write(f.toString().padLeft(2, '0'));
  return buf.toString();
}
