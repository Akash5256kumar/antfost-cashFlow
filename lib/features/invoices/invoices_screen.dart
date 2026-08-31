import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import 'domain/entities/invoice.dart';
import 'presentation/bloc/invoices_bloc.dart';
import 'presentation/bloc/invoices_event.dart';
import 'presentation/bloc/invoices_state.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = AppColors.textPrimary;
const Color _textGrey = AppColors.textSecondary;
const Color _fieldBorder = AppColors.cardBorder;
const Color _bodyBg = AppColors.background;
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
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () {
                        context.read<InvoicesBloc>().add(
                          const RetryInvoicesEvent(),
                        );
                      },
                    ),
                  ),
                );
            } else if (state is InvoicesInitial) {
              context.read<InvoicesBloc>().add(const FetchInvoicesEvent());
            }
          },
          builder: (context, state) {
            // Determine active filter index for chip highlighting.
            final activeFilterIndex = state is InvoicesSuccess
                ? state.filterIndex
                : 0;

            return Column(
              children: [
                // App bar
                _InvoicesAppBar(),

                // Search
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(16),
                    context.scaled(16),
                    0,
                  ),
                  child: _SearchBar(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<InvoicesBloc>().add(
                        SearchInvoicesEvent(query),
                      );
                    },
                  ),
                ),

                // Filter chips
                Padding(
                  padding: EdgeInsets.fromLTRB(0, context.scaled(14), 0, 0),
                  child: SizedBox(
                    height: context.scaled(38),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(16),
                      ),
                      itemCount: _filters.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: context.scaled(8)),
                      itemBuilder: (_, i) => _FilterChip(
                        label: _filters[i],
                        isSelected: activeFilterIndex == i,
                        onTap: () {
                          context.read<InvoicesBloc>().add(
                            FilterInvoicesEvent(i),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: context.scaledV(16)),

                // List area — driven by BLoC state
                Expanded(child: _buildListArea(state)),
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
        return Center(
          child: Text(
            'No invoices found.',
            style: TextStyle(fontSize: context.scaled(15), color: _textGrey),
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.fromLTRB(
          context.scaled(16),
          0,
          context.scaled(16),
          context.scaled(32),
        ),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: context.scaledV(12)),
        itemBuilder: (_, i) => _InvoiceCard(
          item: items[i],
          onTap: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.invoiceDetails, arguments: items[i]),
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
      padding: EdgeInsets.fromLTRB(
        context.scaled(16),
        0,
        context.scaled(16),
        context.scaled(32),
      ),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(height: context.scaledV(12)),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          height: context.scaled(100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.scaled(16)),
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
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaled(8),
        context.scaled(16),
        context.scaled(8),
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
          Text(
            'Invoices',
            style: TextStyle(
              fontSize: context.scaled(22),
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
      height: context.scaled(56),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(14)),
        border: Border.all(color: const Color(0xFF111111), width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(width: context.scaled(16)),
          Icon(
            Icons.search_rounded,
            size: context.scaled(22),
            color: _textDark,
          ),
          SizedBox(width: context.scaled(10)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(fontSize: context.scaled(16), color: _textDark),
              decoration: InputDecoration(
                hintText: 'Search By Order ID or type',
                hintStyle: TextStyle(
                  fontSize: context.scaled(16),
                  color: _textGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: context.scaled(10),
                ),
              ),
            ),
          ),
          SizedBox(width: context.scaled(16)),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(18),
          vertical: context.scaled(8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(20)),
          border: Border.all(
            color: isSelected ? AppColors.primary : _fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(14),
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
        padding: EdgeInsets.all(context.scaled(13)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(14)),
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
                  width: context.scaled(34),
                  height: context.scaled(34),
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(context.scaled(8)),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: context.scaled(18),
                    color: _textGrey,
                  ),
                ),
                SizedBox(width: context.scaled(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.id,
                        style: TextStyle(
                          fontSize: context.scaled(13.5),
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        'Order ID: ${item.orderId}',
                        style: TextStyle(
                          fontSize: context.scaled(11.5),
                          color: _textGrey,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.scaled(8)),
                _BadgesRow(types: item.types, status: item.status),
              ],
            ),

            SizedBox(height: context.scaledV(10)),

            // Total amount + date
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: context.scaled(11.5),
                        color: _textGrey,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: context.scaledV(3)),
                    Text(
                      'AED ${_fmt(item.totalAmount)}',
                      style: TextStyle(
                        fontSize: context.scaled(16),
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
                  style: TextStyle(
                    fontSize: context.scaled(11.5),
                    color: _textGrey,
                    height: 1.2,
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
        bg: AppColors.primaryContainer,
        fg: AppColors.primary,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (types.contains(InvoiceType.vat)) ...[
          _Badge(
            label: 'VAT',
            bg: AppColors.primaryContainer,
            fg: AppColors.primary,
          ),
          SizedBox(width: context.scaled(4)),
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
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(8),
        vertical: context.scaled(3),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.scaled(16)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.scaled(10.5),
          fontWeight: FontWeight.w600,
          color: fg,
        ),
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
        AppColors.primaryContainer,
        AppColors.primary,
      ),
    };
    return _Badge(label: label, bg: bg, fg: fg);
  }
}
