import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_site_access_screen.dart';
import 'new_cash_order_draft.dart';
import 'order_step_widgets.dart';

// ── Pump option enum ─────────────────────────────────────────────────────────

enum _PumpSize { small, medium, big }

const _structureRefs = [
  {'title': 'Slab', 'image': AppAssets.mixThumb4},
  {'title': 'Raft', 'image': AppAssets.mixThumb5},
  {'title': 'Pile', 'image': AppAssets.mixThumb6},
  {'title': 'Column', 'image': AppAssets.mixThumb7},
];

// ── Screen ────────────────────────────────────────────────────────────────────

class NewCashOrderOtherScreen extends StatefulWidget {
  const NewCashOrderOtherScreen({
    super.key,
    required this.mixCode,
    required this.quantity,
    this.draft,
  });

  final MixCodeItem mixCode;
  final int quantity;
  final NewCashOrderDraft? draft;

  @override
  State<NewCashOrderOtherScreen> createState() =>
      _NewCashOrderOtherScreenState();
}

class _NewCashOrderOtherScreenState extends State<NewCashOrderOtherScreen> {
  String _structureRef = 'Slab';

  bool _pump = true;
  _PumpSize _pumpSize = _PumpSize.medium;
  bool _pumpExpanded = true;

  bool _technician = true;
  int _cubeMoulds = 6;
  bool _technicianExpanded = true;

  bool _temperature = false;
  bool _temperatureExpanded = false;

  bool _labTesting = false;
  bool _labTestingExpanded = false;

  bool _otherService = false;
  bool _otherServiceExpanded = false;

  void _onContinue() {
    String pumpName = 'No Pump';
    if (_pump) {
      switch (_pumpSize) {
        case _PumpSize.small:
          pumpName = 'Small Pump (Up to 42 m)';
          break;
        case _PumpSize.medium:
          pumpName = 'Medium Pump (43-52 m)';
          break;
        case _PumpSize.big:
          pumpName = 'Big Pump (53 m and above)';
          break;
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderSiteAccessScreen(
          mixCode: widget.mixCode,
          quantity: widget.quantity,
          structureRef: _structureRef,
          technicianRequired: _technician,
          temperatureControl: _temperature,
          temperature: null,
          pumpRequired: _pump,
          pumpName: pumpName,
          cubeMould: _technician,
          numMoulds: _technician ? _cubeMoulds : 0,
          draft: widget.draft?.copyWith(
            structureRef: _structureRef,
            technicianRequired: _technician,
            temperatureControl: _temperature,
            pumpRequired: _pump,
            pumpName: pumpName,
            cubeMould: _technician,
            numMoulds: _technician ? _cubeMoulds : 0,
            labTesting: _labTesting,
            otherService: _otherService,
          ),
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
            const OrderStepperSection(currentStep: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.scaled(24),
                  context.scaled(8),
                  context.scaled(24),
                  context.scaled(112) + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Services',
                      style: TextStyle(
                        fontSize: context.scaled(22),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                        color: const Color(0xFF1F2533),
                      ),
                    ),
                    SizedBox(height: context.scaledV(3)),
                    Text(
                      'Select the structure type and services required for this delivery.',
                      style: TextStyle(
                        fontSize: context.scaled(13.5),
                        color: kOrderTextGrey,
                      ),
                    ),
                    SizedBox(height: context.scaledV(18)),

                    // Structure Type
                    Text(
                      'Structure Type',
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2533),
                      ),
                    ),
                    SizedBox(height: context.scaledV(6)),
                    _StructureTypeDropdown(
                      value: _structureRef,
                      onChanged: (v) => setState(() => _structureRef = v),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // Concrete Pump
                    _ServiceCard(
                      isSelected: _pump,
                      onToggleCheck: (v) => setState(() => _pump = v),
                      isExpanded: _pumpExpanded,
                      onToggleExpand: () =>
                          setState(() => _pumpExpanded = !_pumpExpanded),
                      title: 'Concrete Pump',
                      subtitle: 'Assigned and tracked as a separate resource',
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(context.scaled(8)),
                        child: Image.asset(
                          AppAssets.mixThumb8,
                          width: context.scaled(66),
                          height: context.scaled(42),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Pump Size',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2533),
                            ),
                          ),
                          SizedBox(height: context.scaledV(10)),
                          Row(
                            children: [
                              Expanded(
                                child: _PumpSizeCard(
                                  title: 'Small Pump',
                                  subtitle: 'Up to 42 m',
                                  isSelected: _pumpSize == _PumpSize.small,
                                  onTap: () => setState(
                                    () => _pumpSize = _PumpSize.small,
                                  ),
                                ),
                              ),
                              SizedBox(width: context.scaled(8)),
                              Expanded(
                                child: _PumpSizeCard(
                                  title: 'Medium Pump',
                                  subtitle: '43–52 m',
                                  isSelected: _pumpSize == _PumpSize.medium,
                                  onTap: () => setState(
                                    () => _pumpSize = _PumpSize.medium,
                                  ),
                                ),
                              ),
                              SizedBox(width: context.scaled(8)),
                              Expanded(
                                child: _PumpSizeCard(
                                  title: 'Big Pump',
                                  subtitle: '53 m and above',
                                  isSelected: _pumpSize == _PumpSize.big,
                                  onTap: () =>
                                      setState(() => _pumpSize = _PumpSize.big),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // Technician
                    _ServiceCard(
                      isSelected: _technician,
                      onToggleCheck: (v) => setState(() => _technician = v),
                      isExpanded: _technicianExpanded,
                      onToggleExpand: () => setState(
                        () => _technicianExpanded = !_technicianExpanded,
                      ),
                      title: 'Technician',
                      subtitle:
                          'On-site support for sampling and quality control',
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(context.scaled(8)),
                        child: Image.asset(
                          AppAssets.mixThumb9,
                          width: context.scaled(66),
                          height: context.scaled(42),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(14),
                          vertical: context.scaledV(12),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            context.scaled(12),
                          ),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Cube Mould Quantity',
                                style: TextStyle(
                                  fontSize: context.scaled(12.5),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2533),
                                ),
                              ),
                            ),
                            SizedBox(width: context.scaled(4)),
                            GestureDetector(
                              onTap: () {
                                if (_cubeMoulds > 6) {
                                  setState(() => _cubeMoulds--);
                                }
                              },
                              child: Container(
                                width: context.scaled(32),
                                height: context.scaled(32),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    context.scaled(8),
                                  ),
                                ),
                                child: Text(
                                  '−',
                                  style: TextStyle(
                                    fontSize: context.scaled(20),
                                    color: kOrderTextGrey,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: context.scaled(48),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    '$_cubeMoulds',
                                    style: TextStyle(
                                      fontSize: context.scaled(15),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1F2533),
                                    ),
                                  ),
                                  Text(
                                    'Minimum 6',
                                    style: TextStyle(
                                      fontSize: context.scaled(7),
                                      color: kOrderTextGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() => _cubeMoulds++);
                              },
                              child: Container(
                                width: context.scaled(32),
                                height: context.scaled(32),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    context.scaled(8),
                                  ),
                                ),
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: context.scaled(20),
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),

                    // Temperature Control
                    _ServiceCard(
                      isSelected: _temperature,
                      onToggleCheck: (v) => setState(() => _temperature = v),
                      isExpanded: _temperatureExpanded,
                      onToggleExpand: () => setState(
                        () => _temperatureExpanded = !_temperatureExpanded,
                      ),
                      title: 'Temperature Control',
                      subtitle: 'Special temperature requirement',
                      leading: const _ServiceIcon(
                        icon: Icons.light_mode_outlined,
                      ),
                    ),
                    SizedBox(height: context.scaledV(10)),

                    // Laboratory Testing
                    _ServiceCard(
                      isSelected: _labTesting,
                      onToggleCheck: (v) => setState(() => _labTesting = v),
                      isExpanded: _labTestingExpanded,
                      onToggleExpand: () => setState(
                        () => _labTestingExpanded = !_labTestingExpanded,
                      ),
                      title: 'Laboratory Testing',
                      subtitle: 'Testing to meet project specifications',
                      leading: const _ServiceIcon(icon: Icons.science_outlined),
                    ),
                    SizedBox(height: context.scaledV(10)),

                    // Other Approved Service
                    _ServiceCard(
                      isSelected: _otherService,
                      onToggleCheck: (v) => setState(() => _otherService = v),
                      isExpanded: _otherServiceExpanded,
                      onToggleExpand: () => setState(
                        () => _otherServiceExpanded = !_otherServiceExpanded,
                      ),
                      title: 'Other Approved Service',
                      subtitle: 'Add a service request',
                      leading: const _ServiceIcon(
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    SizedBox(height: context.scaledV(28)),

                    // Continue Button
                    PrimaryButton(
                      arrow: true,
                      label: 'Continue to Site Access',
                      onPressed: _onContinue,
                    ),
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

// ── Dropdown structure card ───────────────────────────────────────────────────

class _StructureTypeDropdown extends StatefulWidget {
  const _StructureTypeDropdown({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_StructureTypeDropdown> createState() => _StructureTypeDropdownState();
}

class _StructureTypeDropdownState extends State<_StructureTypeDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final selectedItem = _structureRefs.firstWhere(
      (e) => e['title'] == widget.value,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(
          color: _isExpanded ? AppColors.primary : const Color(0xFFE2E8F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E1946),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(18),
                vertical: context.scaledV(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.scaled(38),
                    height: context.scaled(38),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(context.scaled(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.scaled(12)),
                      child: Image.asset(
                        selectedItem['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: context.scaled(14)),
                  Expanded(
                    child: Text(
                      selectedItem['title']!,
                      style: TextStyle(
                        fontSize: context.scaled(14.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2533),
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: kOrderTextGrey,
                    size: context.scaled(20),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            // Expanded List
            ..._structureRefs.map((item) {
              final isSelected = item['title'] == widget.value;
              return GestureDetector(
                onTap: () {
                  widget.onChanged(item['title']!);
                  setState(() => _isExpanded = false);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaled(18),
                    vertical: context.scaledV(13),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.scaled(34),
                        height: context.scaled(34),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(
                            context.scaled(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            context.scaled(10),
                          ),
                          child: Image.asset(item['image']!, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: context.scaled(14)),
                      Expanded(
                        child: Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            color: const Color(0xFF1F2533),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: context.scaled(22),
                          height: context.scaled(22),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            color: AppColors.primary,
                          ),
                          child: Container(
                            width: context.scaled(9),
                            height: context.scaled(9),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: context.scaled(22),
                          height: context.scaled(22),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD3D1E4),
                              width: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

// ── Generic Service Card ──────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.isSelected,
    required this.onToggleCheck,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.child,
  });

  final bool isSelected;
  final ValueChanged<bool> onToggleCheck;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E1946),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(18),
              vertical: context.scaledV(14),
            ),
            child: Row(
              children: [
                _FigmaCheckbox(value: isSelected, onChanged: onToggleCheck),
                SizedBox(width: context.scaled(12)),
                leading,
                SizedBox(width: context.scaled(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: context.scaled(14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2533),
                        ),
                      ),
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: context.scaled(11.5),
                          color: kOrderTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onToggleExpand,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(left: context.scaled(12)),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: kOrderTextGrey,
                      size: context.scaled(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected && isExpanded && child != null) ...[
            const Divider(color: Color(0xFFE2E8F0), height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.scaled(18),
                context.scaledV(14),
                context.scaled(18),
                context.scaledV(18),
              ),
              child: child,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Custom Widgets ────────────────────────────────────────────────────────────

class _FigmaCheckbox extends StatelessWidget {
  const _FigmaCheckbox({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: context.scaled(22),
        height: context.scaled(22),
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(context.scaled(6)),
          border: Border.all(
            color: value ? AppColors.primary : const Color(0xFFD3D1E4),
            width: 2,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: context.scaled(14), color: Colors.white)
            : null,
      ),
    );
  }
}

class _PumpSizeCard extends StatelessWidget {
  const _PumpSizeCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.scaledV(14),
          horizontal: context.scaled(4),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(12)),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: context.scaled(18),
              height: context.scaled(18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFD3D1E4),
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.white,
              ),
              child: isSelected
                  ? Container(
                      width: context.scaled(8),
                      height: context.scaled(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            SizedBox(height: context.scaledV(12)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.scaled(12),
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : const Color(0xFF1F2533),
              ),
            ),
            SizedBox(height: context.scaledV(4)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.scaled(11),
                color: kOrderTextGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.scaled(36),
      height: context.scaled(36),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // var(--muted)
        borderRadius: BorderRadius.circular(context.scaled(10)),
      ),
      child: Icon(icon, size: context.scaled(18), color: AppColors.primary),
    );
  }
}
