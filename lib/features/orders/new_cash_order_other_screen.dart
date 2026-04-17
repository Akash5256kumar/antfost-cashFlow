import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_review_screen.dart';
import 'order_step_widgets.dart';

// ── Pump data model ────────────────────────────────────────────────────────────

class PumpItem {
  const PumpItem({
    required this.name,
    required this.priceSmall,
    required this.priceMid,
    required this.priceLarge,
  });

  final String name;
  final int priceSmall; // <20 m³
  final int priceMid;   // 20-70 m³
  final int priceLarge; // >70 m³
}

const _pumps = [
  PumpItem(name: 'Small Pump',       priceSmall: 1000, priceMid: 700,  priceLarge: 500),
  PumpItem(name: '42-52m Pump',      priceSmall: 1500, priceMid: 600,  priceLarge: 450),
  PumpItem(name: 'Big Pump (56-63m)',priceSmall: 2000, priceMid: 1500, priceLarge: 300),
];

const _structureRefs = ['Foundation', 'Column', 'Slab', 'Beam', 'Wall'];
const _temperatures   = [18, 20, 22, 25];

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderOtherScreen extends StatefulWidget {
  const NewCashOrderOtherScreen({
    super.key,
    required this.mixCode,
    required this.quantity,
  });

  final MixCodeItem mixCode;
  final int quantity;

  @override
  State<NewCashOrderOtherScreen> createState() =>
      _NewCashOrderOtherScreenState();
}

class _NewCashOrderOtherScreenState extends State<NewCashOrderOtherScreen> {
  String _structureRef = 'Foundation';

  bool _technician    = true;
  bool _temperature   = false;
  bool _pump          = false;
  bool _cubeMould     = false;

  int  _selectedTemp  = 20;
  int? _selectedPump;    // index into _pumps
  final _mouldController = TextEditingController(text: '9');

  @override
  void dispose() {
    _mouldController.dispose();
    super.dispose();
  }

  Future<void> _pickStructureRef() async {
    final v = await _showPickerSheet<String>(
      context: context,
      title: 'Structure Ref',
      items: _structureRefs,
      selected: _structureRef,
      labelOf: (s) => s,
    );
    if (v != null && mounted) setState(() => _structureRef = v);
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderReviewScreen(
          mixCode: widget.mixCode,
          quantity: widget.quantity,
          structureRef: _structureRef,
          technicianRequired: _technician,
          temperatureControl: _temperature,
          temperature: _temperature ? _selectedTemp : null,
          pumpRequired: _pump,
          pumpName: _pump && _selectedPump != null
              ? _pumps[_selectedPump!].name
              : null,
          cubeMould: _cubeMould,
          numMoulds: _cubeMould ? int.tryParse(_mouldController.text) ?? 0 : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OrderStepAppBar(subtitle: 'Other'),
            const OrderStepperSection(currentStep: 4),
            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Other Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Structure Ref
                      _DropdownTile(
                        label: 'Structure Ref',
                        value: _structureRef,
                        onTap: _pickStructureRef,
                      ),
                      const SizedBox(height: 12),

                      // Technician Required
                      _ToggleCard(
                        label: 'Technician Required?',
                        value: _technician,
                        onToggle: (v) => setState(() => _technician = v),
                        child: _infoBanner('Technician will be arranged'),
                      ),
                      const SizedBox(height: 12),

                      // Temperature Control
                      _ToggleCard(
                        label: 'Temperature Control Required?',
                        value: _temperature,
                        onToggle: (v) => setState(() => _temperature = v),
                        child: _TempSection(
                          selected: _selectedTemp,
                          onSelect: (t) => setState(() => _selectedTemp = t),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Pump
                      _ToggleCard(
                        label: _pump ? 'Select Pump Type' : 'Pump Required?',
                        value: _pump,
                        onToggle: (v) => setState(() => _pump = v),
                        child: _PumpSection(
                          pumps: _pumps,
                          selected: _selectedPump,
                          onSelect: (i) => setState(() => _selectedPump = i),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cube Mould
                      _ToggleCard(
                        label: 'Cube Mould Required',
                        value: _cubeMould,
                        onToggle: (v) => setState(() => _cubeMould = v),
                        child: _MouldInput(controller: _mouldController),
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

// ── Dropdown tile ─────────────────────────────────────────────────────────────

class _DropdownTile extends StatelessWidget {
  const _DropdownTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
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
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kOrderFieldBorder),
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
                        color: kOrderLabelGrey,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kOrderTextDark,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: kOrderTextDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Toggle card ───────────────────────────────────────────────────────────────

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.label,
    required this.value,
    required this.onToggle,
    required this.child,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kOrderFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kOrderTextDark,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onToggle,
                activeColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
              ),
            ],
          ),
          if (value) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }
}

// ── Info banner ───────────────────────────────────────────────────────────────

Widget _infoBanner(String text) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFEDE9FB),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
        height: 1.3,
      ),
    ),
  );
}

// ── Temperature section ───────────────────────────────────────────────────────

class _TempSection extends StatelessWidget {
  const _TempSection({required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temperature (°C)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: kOrderTextGrey,
            height: 1.33,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _temperatures
              .map(
                (t) => Padding(
                  padding: EdgeInsets.only(
                    right: t == _temperatures.last ? 0 : 10,
                  ),
                  child: _TempChip(
                    value: t,
                    isSelected: t == selected,
                    onTap: () => onSelect(t),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: const Text(
            '+Add custom temperature',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TempChip extends StatelessWidget {
  const _TempChip({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : kOrderFieldBorder,
          ),
        ),
        child: Text(
          '+ ${value}°C',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : kOrderTextDark,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// ── Pump section ──────────────────────────────────────────────────────────────

class _PumpSection extends StatelessWidget {
  const _PumpSection({
    required this.pumps,
    required this.selected,
    required this.onSelect,
  });

  final List<PumpItem> pumps;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(pumps.length, (i) {
        final p = pumps[i];
        final isSelected = i == selected;
        return Padding(
          padding: EdgeInsets.only(bottom: i < pumps.length - 1 ? 10 : 0),
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : kOrderFieldBorder,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kOrderTextDark,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '<20 m³: AED ${p.priceSmall}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kOrderTextGrey,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          '20-70 m³: AED ${p.priceMid}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kOrderTextGrey,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          '>70 m³: AED ${p.priceLarge}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kOrderTextGrey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'AED ${p.priceLarge}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Cube mould input ──────────────────────────────────────────────────────────

class _MouldInput extends StatelessWidget {
  const _MouldInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kOrderFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'No. of Moulds',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: kOrderLabelGrey,
                height: 1.33,
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: kOrderRequiredPink),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kOrderTextDark,
              height: 1.25,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Picker sheet helper ───────────────────────────────────────────────────────

Future<T?> _showPickerSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required T selected,
  required String Function(T) labelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x4D000000),
    builder: (_) => DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kOrderTextDark,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    labelOf(item),
                    style: const TextStyle(
                      fontSize: 16,
                      color: kOrderTextDark,
                    ),
                  ),
                  trailing: item == selected
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(item),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
