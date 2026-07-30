import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import 'domain/entities/invoice.dart';
import 'presentation/bloc/invoices_bloc.dart';
import 'presentation/bloc/invoices_event.dart';
import 'presentation/bloc/invoices_state.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg = Color(0xFFF2F2F7);
const Color _iconBg = Color(0xFFF1F1F1);

const _filters = ['All', 'Receipts', 'VAT Invoices', 'Ready'];

// ── Screen ────────────────────────────────────────────────────────────────────
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trigger the initial data fetch via BLoC.
    context.read<InvoicesBloc>().add(const FetchInvoicesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<InvoicesBloc, InvoicesState>(
          listener: (context, state) {
            if (state is InvoicesError) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      context
                          .read<InvoicesBloc>()
                          .add(const RetryInvoicesEvent());
                    },
                  ),
                ));
            } else if (state is InvoicesInitial) {
              context.read<InvoicesBloc>().add(const FetchInvoicesEvent());
            }
          },
          builder: (context, state) {
            // Determine active filter index for chip highlighting.
            final activeFilterIndex =
                state is InvoicesSuccess ? state.filterIndex : 0;

            return Column(
              children: [
                // App bar
                _InvoicesAppBar(),

                // Search
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _SearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      context
                          .read<InvoicesBloc>()
                          .add(SearchInvoicesEvent(query));
                    },
                  ),
                ),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (_, i) => _FilterChip(
                        label: _filters[i],
                        isSelected: activeFilterIndex == i,
                        onTap: () {
                          context
                              .read<InvoicesBloc>()
                              .add(FilterInvoicesEvent(i));
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // List area — driven by BLoC state
                Expanded(
                  child: _buildListArea(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the main list area based on the current [state].
  Widget _buildListArea(InvoicesState state) {
    if (state is InvoicesLoading) {
      return _ShimmerList();
    }

    if (state is InvoicesSuccess) {
      final items = state.filteredInvoices;
      if (items.isEmpty) {
        return const Center(
          child: Text(
            'No invoices found.',
            style: TextStyle(fontSize: 15, color: _textGrey),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _InvoiceCard(
          item: items[i],
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.invoiceDetails,
            arguments: items[i],
          ),
        ),
      );
    }

    // InvoicesError and InvoicesInitial — show empty (listener shows snackbar).
    return const SizedBox.shrink();
  }
}

// ── Shimmer placeholder list ──────────────────────────────────────────────────
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _InvoicesAppBar extends StatelessWidget {
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
          const Text(
            'Invoices',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: const Color(0xFF111111), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, size: 22, color: _textDark),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16, color: _textDark),
              decoration: const InputDecoration(
                hintText: 'Search By Order ID or type',
                hintStyle: TextStyle(fontSize: 16, color: _textGrey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : _fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }
}

// ── Invoice card ──────────────────────────────────────────────────────────────
class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.item, required this.onTap});

  /// Domain entity — replaces former local InvoiceItem.
  final Invoice item;
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
            // Top row: icon + id + badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 22,
                    color: _textGrey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.id,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order ID: ${item.orderId}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: _textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _BadgesRow(types: item.types, status: item.status),
              ],
            ),

            const SizedBox(height: 14),

            // Total amount + date
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textGrey,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AED ${_fmt(item.totalAmount)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 13,
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

  static String _fmt(double v) {
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

// ── Badges row ────────────────────────────────────────────────────────────────
class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.types, required this.status});
  final List<InvoiceType> types;
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == InvoiceStatus.vatInvoiceReady) {
      return _Badge(
        label: 'VAT Invoice Ready',
        bg: const Color(0xFFEDE9FB),
        fg: AppColors.primary,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (types.contains(InvoiceType.vat)) ...[
          _Badge(
            label: 'VAT',
            bg: const Color(0xFFEDE9FB),
            fg: AppColors.primary,
          ),
          const SizedBox(width: 6),
        ],
        _StatusBadge(status: status),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      InvoiceStatus.paid => (
        'Paid',
        const Color(0xFFDCFCE7),
        const Color(0xFF16A34A),
      ),
      InvoiceStatus.sent => (
        'Sent',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
      InvoiceStatus.draft => ('Draft', const Color(0xFFF1F1F1), _textDark),
      InvoiceStatus.vatInvoiceReady => (
        'Ready',
        const Color(0xFFEDE9FB),
        AppColors.primary,
      ),
    };
    return _Badge(label: label, bg: bg, fg: fg);
  }
}
