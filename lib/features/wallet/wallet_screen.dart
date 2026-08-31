import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import 'add_funds_screen.dart';
import 'domain/entities/transaction.dart';
import 'domain/entities/wallet_balance.dart';
import 'presentation/bloc/wallet_bloc.dart';
import 'presentation/bloc/wallet_event.dart';
import 'presentation/bloc/wallet_state.dart';
import 'transaction_history_screen.dart';

const _filters = ['All', 'Top-ups', 'Payments', 'Refunds'];

/// Ported from the new Figma design's `screens/Wallet.tsx`.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletSuccess? _lastKnown;
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(const FetchWalletDataEvent());
  }

  void _openAddFundsScreen(BuildContext ctx) {
    Navigator.of(
      ctx,
    ).push(MaterialPageRoute(builder: (_) => const AddFundsScreen()));
  }

  List<WalletTransaction> _filtered(List<WalletTransaction> all) {
    switch (_filterIndex) {
      case 1:
        return all.where((t) => t.type == TransactionType.deposit).toList();
      case 2:
        return all
            .where((t) => t.type == TransactionType.orderPayment)
            .toList();
      case 3:
        return all.where((t) => t.type == TransactionType.refund).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        onBellTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      bottomNavigationBar: const AppTabBottomNavBar(currentTab: AppTab.wallet),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletSuccess) {
            _lastKnown = state;
          } else if (state is WalletFundsAdded) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Funds added successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () =>
                        context.read<WalletBloc>().add(const RetryWalletEvent()),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          final balance = state is WalletSuccess
              ? state.balance
              : _lastKnown?.balance;
          final transactions = state is WalletSuccess
              ? state.transactions
              : _lastKnown?.transactions ?? const <WalletTransaction>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Wallet', style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 24)),
                const SizedBox(height: 14),
                if (balance == null)
                  const _BalanceShimmer()
                else
                  _BalanceCard(balance: balance),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.add,
                        label: 'Top Up',
                        onTap: () => _openAddFundsScreen(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.arrow_forward_rounded,
                        label: 'Withdraw',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.credit_card_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Wallet can be combined with Card or Bank Transfer for partial payments.',
                          style: AppTextStyles.cardSubtitle(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Transactions', style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 20)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(_filters.length, (i) {
                    final active = i == _filterIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _filterIndex = i),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: active ? AppColors.primary : AppColors.cardBorder, width: active ? 2 : 1)),
                          ),
                          child: Text(
                            _filters[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? AppColors.primary : AppColors.textSecondary),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                if (state is WalletLoading && _lastKnown == null)
                  const _TransactionShimmer()
                else if (_filtered(transactions).isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('No transactions', style: AppTextStyles.cardSubtitle(context))),
                  )
                else
                  ..._filtered(transactions).map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _TransactionRow(transaction: t),
                    ),
                  ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                    ),
                    child: Text('See full history', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});
  final WalletBalance balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_balance_wallet_rounded, color: Colors.white70),
          const SizedBox(height: 12),
          const Text('AVAILABLE BALANCE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.6)),
          const SizedBox(height: 4),
          Text(
            'AED ${balance.estimatedValueAed.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BalanceStat(label: 'Available', value: '${balance.availableTokenM3.toStringAsFixed(0)} m³'),
              ),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(
                child: _BalanceStat(label: 'Reserved', value: '${balance.reservedTokenM3.toStringAsFixed(0)} m³'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});
  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final icon = switch (transaction.type) {
      TransactionType.deposit => Icons.arrow_downward_rounded,
      TransactionType.orderPayment => Icons.local_shipping_rounded,
      TransactionType.reserved => Icons.lock_outline_rounded,
      TransactionType.refund => Icons.refresh_rounded,
    };
    final statusColor = switch (transaction.status) {
      TransactionStatus.completed => AppColors.success,
      TransactionStatus.pending => AppColors.warning,
      TransactionStatus.reserved => AppColors.textSecondary,
      TransactionStatus.failed => AppColors.error,
    };
    final amountColor = transaction.isCredit ? AppColors.success : AppColors.textPrimary;
    final amountText = '${transaction.isCredit ? '+' : '-'}AED ${transaction.amount.toStringAsFixed(0)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 19, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.cardTitle(context)),
                Row(
                  children: [
                    Flexible(child: Text(transaction.date, overflow: TextOverflow.ellipsis, style: AppTextStyles.cardSubtitle(context).copyWith(fontSize: 11))),
                    const SizedBox(width: 6),
                    Container(width: 5, height: 5, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(transaction.status.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: statusColor)),
                  ],
                ),
              ],
            ),
          ),
          Text(amountText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: amountColor)),
          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.iconMuted),
        ],
      ),
    );
  }
}

class _BalanceShimmer extends StatelessWidget {
  const _BalanceShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.circleInactive,
      highlightColor: AppColors.muted,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}

class _TransactionShimmer extends StatelessWidget {
  const _TransactionShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.circleInactive,
      highlightColor: AppColors.muted,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
