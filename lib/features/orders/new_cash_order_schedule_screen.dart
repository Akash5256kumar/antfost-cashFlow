import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
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
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _selectedTimeWindowIndex = 0;
  int _intervalMinutes = 15;
  final TextEditingController _notesController = TextEditingController();
  late final TextEditingController _intervalController;

  final List<DateTime> _dates = List.generate(
      14, (i) => DateTime.now().add(Duration(days: i))); 

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController(text: '$_intervalMinutes');
    _intervalController.addListener(() {
      final val = int.tryParse(_intervalController.text);
      if (val != null) {
        _intervalMinutes = val;
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  void _incrementInterval() {
    setState(() {
      _intervalMinutes += 5;
      _intervalController.text = '$_intervalMinutes';
    });
  }

  void _decrementInterval() {
    if (_intervalMinutes > 5) {
      setState(() {
        _intervalMinutes -= 5;
        _intervalController.text = '$_intervalMinutes';
      });
    }
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderOtherScreen(
          mixCode: widget.mixCode,
          quantity: widget.quantity,
        ),
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
            const AppBrandHeader(showBack: true),
            const OrderStepperSection(currentStep: 3),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  context.scaled(24),
                  context.scaled(16),
                  0, // We will put bottom padding inside the column
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OrderStepHeading(
                      title: 'Choose Schedule',
                      subtitle: 'Select your preferred date and time window.',
                    ),
                    SizedBox(height: context.scaledV(24)),

                    // ── Date slider ─────────────────────────────
                    _HorizontalDateSlider(
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onSelect: (d) => setState(() => _selectedDate = d),
                    ),
                    SizedBox(height: context.scaledV(32)),

                    // ── Select Time Window ──────────────────────────
                    Text(
                      'Select Time Window',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    _TimeWindowGrid(
                      selectedIndex: _selectedTimeWindowIndex,
                      onSelect: (i) =>
                          setState(() => _selectedTimeWindowIndex = i),
                    ),
                    SizedBox(height: context.scaledV(32)),

                    // ── Delivery interval ──────────────────────────
                    Text(
                      'Requested Supply Interval',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    _IntervalStepper(
                      controller: _intervalController,
                      onDecrement: _decrementInterval,
                      onIncrement: _incrementInterval,
                    ),
                    SizedBox(height: context.scaledV(8)),
                    Text(
                      'Requested interval helps ANTFAST prepare your proposal.',
                      style: TextStyle(
                        fontSize: context.scaled(12.5),
                        color: kOrderTextGrey,
                      ),
                    ),
                    SizedBox(height: context.scaledV(32)),

                    // ── Schedule Notes ──────────────────────────────
                    Text(
                      'Schedule Notes (Optional)',
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w600,
                        color: kOrderTextDark,
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                    _NotesField(controller: _notesController),
                    SizedBox(height: context.scaledV(32)),

                    // ── Continue Button ─────────────────────────────
                    PrimaryButton(
                      arrow: true,
                      label: 'Continue to Services',
                      onPressed: _onContinue,
                    ),
                    
                    SizedBox(height: context.scaledV(32)),

                    // ── Footer Illustration ─────────────────────────
                    Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                            ],
                            stops: [0.0, 0.25, 1.0], // Fade the top 25% smoothly
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          AppAssets.artHomeHero,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    // Extra padding for bottom safe area
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + context.scaledV(20)),
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

// ── Horizontal Date Slider ───────────────────────────────────────────────────

class _HorizontalDateSlider extends StatelessWidget {
  const _HorizontalDateSlider({
    required this.dates,
    required this.selectedDate,
    required this.onSelect,
  });

  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  static const List<String> _weekdays = [
    '',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  static const List<String> _months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.scaled(32),
          height: context.scaled(32),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.scaled(10)),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(Icons.chevron_left, color: kOrderTextDark, size: context.scaled(18)),
        ),
        SizedBox(width: context.scaled(8)),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((d) {
                final isSelected = d.year == selectedDate.year &&
                    d.month == selectedDate.month &&
                    d.day == selectedDate.day;
                return Padding(
                  padding: EdgeInsets.only(right: context.scaled(8)),
                  child: GestureDetector(
                    onTap: () => onSelect(d),
                    child: Container(
                      constraints: BoxConstraints(minWidth: context.scaled(62)),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaled(8),
                        vertical: context.scaledV(12),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF6F8FF) : Colors.white,
                        borderRadius: BorderRadius.circular(context.scaled(12)),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFF1F5F9),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _weekdays[d.weekday],
                            style: TextStyle(
                              fontSize: context.scaled(12.5),
                              color: isSelected ? AppColors.primary : kOrderTextDark,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: context.scaledV(4)),
                          Text(
                            '${d.day} ${_months[d.month]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.scaled(12.5),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : kOrderTextDark,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: context.scaledV(8)),
                          if (isSelected)
                            Container(
                              width: context.scaled(18),
                              height: context.scaled(18),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.check, size: context.scaled(12), color: Colors.white),
                            )
                          else
                            Container(
                              width: context.scaled(18),
                              height: context.scaled(18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: context.scaled(8)),
        Container(
          width: context.scaled(32),
          height: context.scaled(32),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.scaled(10)),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(Icons.chevron_right, color: kOrderTextDark, size: context.scaled(18)),
        ),
      ],
    );
  }
}

// ── Time Window Grid ─────────────────────────────────────────────────────────

class _TimeWindowGrid extends StatelessWidget {
  const _TimeWindowGrid({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const List<Map<String, dynamic>> _windows = [
    {'title': 'Morning', 'time': '06:00-12:00', 'icon': Icons.wb_twilight},
    {'title': 'Midday', 'time': '12:00-16:00', 'icon': Icons.wb_sunny_outlined},
    {'title': 'Afternoon', 'time': '16:00-00:00', 'icon': Icons.wb_sunny_outlined},
    {'title': 'Early Night', 'time': '00:00-06:00', 'icon': Icons.nights_stay_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = context.scaled(8);
        final itemWidth = (constraints.maxWidth - gap * 3) / 4;
        return Row(
          children: List.generate(_windows.length, (i) {
            final isSelected = selectedIndex == i;
            return Padding(
              padding: EdgeInsets.only(right: i == _windows.length - 1 ? 0 : gap),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  width: itemWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaled(4),
                    vertical: context.scaledV(12),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF6F8FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(context.scaled(12)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFF1F5F9),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _windows[i]['icon'] as IconData,
                        size: context.scaled(24),
                        color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                      ),
                      SizedBox(height: context.scaledV(8)),
                      Text(
                        _windows[i]['title'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.scaled(11.5),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : kOrderTextDark,
                        ),
                      ),
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        _windows[i]['time'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.scaled(9.5),
                          color: isSelected ? AppColors.primary.withValues(alpha: 0.8) : kOrderTextGrey,
                        ),
                      ),
                      SizedBox(height: context.scaledV(12)),
                      if (isSelected)
                        Container(
                          width: context.scaled(20),
                          height: context.scaled(20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.check, size: context.scaled(12), color: Colors.white),
                        )
                      else
                        Container(
                          width: context.scaled(20),
                          height: context.scaled(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Interval Stepper ─────────────────────────────────────────────────────────

class _IntervalStepper extends StatelessWidget {
  const _IntervalStepper({
    required this.controller,
    required this.onDecrement,
    required this.onIncrement,
  });

  final TextEditingController controller;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(12),
        vertical: context.scaledV(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IntervalButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: context.scaled(100),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixText: ' min',
                suffixStyle: TextStyle(
                  fontSize: context.scaled(16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              style: TextStyle(
                fontSize: context.scaled(16),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          _IntervalButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _IntervalButton extends StatelessWidget {
  const _IntervalButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.scaled(36),
        height: context.scaled(36),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(context.scaled(10)),
        ),
        child: Icon(icon, size: context.scaled(18), color: const Color(0xFF64748B)),
      ),
    );
  }
}

// ── Notes Field ──────────────────────────────────────────────────────────────

class _NotesField extends StatefulWidget {
  const _NotesField({required this.controller});
  final TextEditingController controller;

  @override
  State<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends State<_NotesField> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCount);
    super.dispose();
  }

  void _updateCount() {
    setState(() {
      _charCount = widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(12)),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      padding: EdgeInsets.all(context.scaled(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: widget.controller,
            maxLines: 4,
            maxLength: 200,
            style: TextStyle(
              fontSize: context.scaled(14),
              color: kOrderTextDark,
            ),
            decoration: InputDecoration(
              hintText: 'Add any notes or instructions for your delivery...',
              hintStyle: TextStyle(
                fontSize: context.scaled(14),
                color: const Color(0xFF94A3B8),
              ),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              counterText: '', // Hide default counter
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Text(
            '$_charCount/200',
            style: TextStyle(
              fontSize: context.scaled(11),
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
