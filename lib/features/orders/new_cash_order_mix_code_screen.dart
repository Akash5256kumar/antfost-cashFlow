import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'new_cash_order_quantity_screen.dart';
import 'order_step_widgets.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class MixCodeItem {
  const MixCodeItem({
    required this.code,
    required this.type,
    required this.pricePerM3,
  });

  final String code;
  final String type;
  final int pricePerM3;
}

// ── Sample data ───────────────────────────────────────────────────────────────

const _mixCodes = [
  MixCodeItem(code: 'C25/30', type: 'Standard Mix',    pricePerM3: 450),
  MixCodeItem(code: 'C30/37', type: 'Structural Mix',  pricePerM3: 520),
  MixCodeItem(code: 'C35/45', type: 'High Strength',   pricePerM3: 590),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderMixCodeScreen extends StatefulWidget {
  const NewCashOrderMixCodeScreen({super.key});

  @override
  State<NewCashOrderMixCodeScreen> createState() =>
      _NewCashOrderMixCodeScreenState();
}

class _NewCashOrderMixCodeScreenState
    extends State<NewCashOrderMixCodeScreen> {
  MixCodeItem? _selected;

  Future<void> _openPicker() async {
    final result = await showModalBottomSheet<MixCodeItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4D000000),
      builder: (_) => _MixCodePickerSheet(
        items: _mixCodes,
        selected: _selected,
      ),
    );
    if (result != null && mounted) setState(() => _selected = result);
  }

  void _onContinue() {
    final mix = _selected ?? _mixCodes.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderQuantityScreen(mixCode: mix),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OrderStepAppBar(subtitle: 'Mix Code'),
            const OrderStepperSection(currentStep: 1),
            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Choose the concrete mix code for your project',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kOrderTextGrey,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _MixCodeSelectorCard(
                        selected: _selected,
                        onTap: _openPicker,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            OrderStepBottomBar(onContinue: _onContinue),
          ],
        ),
      ),
    );
  }
}

// ── Selector card (idle state) ────────────────────────────────────────────────

class _MixCodeSelectorCard extends StatelessWidget {
  const _MixCodeSelectorCard({
    required this.selected,
    required this.onTap,
  });

  final MixCodeItem? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kOrderFieldBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.view_in_ar_outlined,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selected?.code ?? 'Select a mix code',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected?.type ?? 'Browse available Mix',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kOrderTextGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow button
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: const Icon(Icons.arrow_forward, size: 16, color: kOrderTextDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Picker bottom sheet ───────────────────────────────────────────────────────

class _MixCodePickerSheet extends StatefulWidget {
  const _MixCodePickerSheet({required this.items, required this.selected});

  final List<MixCodeItem> items;
  final MixCodeItem? selected;

  @override
  State<_MixCodePickerSheet> createState() => _MixCodePickerSheetState();
}

class _MixCodePickerSheetState extends State<_MixCodePickerSheet> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<MixCodeItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items
        .where((m) =>
            m.code.toLowerCase().contains(q) ||
            m.type.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 0.7,
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6D6D6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Select Mix Code',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kOrderTextDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Search
                _SearchBar(controller: _search),
                const SizedBox(height: 20),

                // List
                Expanded(
                  child: ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      return _MixCodeTile(
                        item: item,
                        isSelected: item.code == widget.selected?.code,
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: kOrderTextDark,
        ),
        decoration: InputDecoration(
          hintText: 'Search Mix Codes..',
          hintStyle: const TextStyle(fontSize: 16, color: kOrderTextGrey),
          prefixIcon: const Icon(Icons.search_rounded,
              size: 22, color: kOrderTextDark),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFF111111), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFF111111), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Mix code tile ─────────────────────────────────────────────────────────────

class _MixCodeTile extends StatelessWidget {
  const _MixCodeTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final MixCodeItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : kOrderFieldBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.view_in_ar_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Name + type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kOrderTextGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AED ${item.pricePerM3}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kOrderTextDark,
                      height: 1.25,
                    ),
                  ),
                  const Text(
                    'per m³',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: kOrderTextGrey,
                      height: 1.3,
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
