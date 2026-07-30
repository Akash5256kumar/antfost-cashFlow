import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_other_screen.dart';
import 'order_step_widgets.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderScheduleScreen extends StatefulWidget {
  const NewCashOrderScheduleScreen({
    super.key,
    required this.mixCode,
    required this.quantity,
  });

  final MixCodeItem mixCode;
  final int quantity;

  @override
  State<NewCashOrderScheduleScreen> createState() =>
      _NewCashOrderScheduleScreenState();
}

class _NewCashOrderScheduleScreenState
    extends State<NewCashOrderScheduleScreen> {
  DateTime? _deliveryDate;
  int? _selectedTimeSlot;
  bool _splitDelivery = true;
  int _numTrips = 3;
  int _gapMinutes = 30;

  static const _timeSlots = [
    '6 AM - 10 AM (±4 hrs)',
    '6 AM - 12 PM (±6 hrs)',
    '6 AM - 6 PM (±12 hrs)',
    '10 AM - 2 PM',
    '2 PM - 6 PM',
  ];

  static const _tripOptions = [1, 2, 3, 4, 5, 6];
  static const _gapOptions  = [15, 30, 45, 60, 90];

  String get _dateLabel {
    if (_deliveryDate == null) return 'DD-MM-YYYY';
    final d = _deliveryDate!;
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd-$mm-${d.year}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) setState(() => _deliveryDate = picked);
  }

  Future<void> _pickTrips() async {
    final val = await _showPickerSheet<int>(
      context: context,
      title: 'Number of Trips',
      items: _tripOptions,
      selected: _numTrips,
      labelOf: (v) => '$v',
    );
    if (val != null && mounted) setState(() => _numTrips = val);
  }

  Future<void> _pickGap() async {
    final val = await _showPickerSheet<int>(
      context: context,
      title: 'Gap Between Trips',
      items: _gapOptions,
      selected: _gapMinutes,
      labelOf: (v) => '$v min',
    );
    if (val != null && mounted) setState(() => _gapMinutes = val);
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
            const OrderStepAppBar(subtitle: 'Schedule'),
            const OrderStepperSection(currentStep: 3),

            Expanded(
              child: ColoredBox(
                color: kOrderBodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section heading
                      const Text(
                        'Schedule Delivery',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Select your preferred delivery date and time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kOrderTextGrey,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Delivery date ─────────────────────────────
                      _DateField(
                        label: _dateLabel,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 20),

                      // ── Select Time Slot ──────────────────────────
                      const Text(
                        'Select Time Slot',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kOrderTextDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Column(
                        children: List.generate(_timeSlots.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: i < _timeSlots.length - 1 ? 10 : 0,
                            ),
                            child: _TimeSlotTile(
                              label: _timeSlots[i],
                              isSelected: _selectedTimeSlot == i,
                              onTap: () =>
                                  setState(() => _selectedTimeSlot = i),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // ── Split delivery ────────────────────────────
                      _SplitDeliverySection(
                        enabled: _splitDelivery,
                        numTrips: _numTrips,
                        gapMinutes: _gapMinutes,
                        onToggle: (v) =>
                            setState(() => _splitDelivery = v),
                        onPickTrips: _pickTrips,
                        onPickGap: _pickGap,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            OrderStepBottomBar(
              onContinue: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewCashOrderOtherScreen(
                    mixCode: widget.mixCode,
                    quantity: widget.quantity,
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

// ── Date field ────────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});
  final String label;
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
                    const Text(
                      'Delivery Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kOrderLabelGrey,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
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
                Icons.calendar_today_outlined,
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

// ── Time slot tile ────────────────────────────────────────────────────────────

class _TimeSlotTile extends StatelessWidget {
  const _TimeSlotTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
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
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : kOrderFieldBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isSelected ? AppColors.primary : kOrderTextDark,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Split delivery section ────────────────────────────────────────────────────

class _SplitDeliverySection extends StatelessWidget {
  const _SplitDeliverySection({
    required this.enabled,
    required this.numTrips,
    required this.gapMinutes,
    required this.onToggle,
    required this.onPickTrips,
    required this.onPickGap,
  });

  final bool enabled;
  final int numTrips;
  final int gapMinutes;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTrips;
  final VoidCallback onPickGap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle row
        Row(
          children: [
            const Text(
              'Split Delivery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kOrderTextDark,
                height: 1.3,
              ),
            ),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            ),
          ],
        ),

        if (enabled) ...[
          const SizedBox(height: 10),

          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Receive concrete in multiple trips',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Number of Trips
          _DropdownField(
            label: 'Number of Trips',
            value: '$numTrips',
            onTap: onPickTrips,
          ),
          const SizedBox(height: 12),

          // Gap Between Trips
          _DropdownField(
            label: 'Gap Between Trips (minutes)',
            value: '$gapMinutes min',
            onTap: onPickGap,
          ),
          const SizedBox(height: 8),

          const Text(
            'Gap between trips helps truck return/cleaning/refuel',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: kOrderTextGrey,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Dropdown field ────────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  const _DropdownField({
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

// ── Generic picker bottom sheet ───────────────────────────────────────────────

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
    builder: (_) {
      return DecoratedBox(
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
                const SizedBox(height: 12),
                ...items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      labelOf(item),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: kOrderTextDark,
                      ),
                    ),
                    trailing: item == selected
                        ? const Icon(Icons.check_rounded,
                            color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(item),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
