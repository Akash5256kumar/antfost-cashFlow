import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/di/injection.dart';
import '../../core/services/order_api_service.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'new_cash_order_site_access_screen.dart';
import 'new_cash_order_draft.dart';
import 'order_step_widgets.dart';
import '../../core/utils/route_feedback.dart';

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
  Map<String, String> _structureIds = const {};
  List<Map<String, String>> _structureOptions = [
    for (final item in _structureRefs)
      {'title': item['title']!, 'image': item['image']!},
  ];

  bool _pump = true;
  List<Map<String, dynamic>> _pumpTypes = const [];
  List<Map<String, dynamic>> _pumpSizes = const [];
  String? _pumpType;
  double? _pumpSizeFromM;
  double? _pumpSizeUpToM;
  bool _pumpExpanded = true;

  bool _technician = true;
  int _cubeMoulds = 6;
  late final TextEditingController _cubeMouldController;
  bool _technicianExpanded = true;

  bool _temperature = false;
  bool _temperatureExpanded = false;

  bool _labTesting = false;
  bool _labTestingExpanded = false;

  bool _otherService = false;
  bool _otherServiceExpanded = false;

  @override
  void initState() {
    super.initState();
    final saved = widget.draft;
    if (saved != null) {
      _structureRef = saved.structureRef;
      _pump = saved.pumpRequired;
      _pumpType = saved.pumpType;
      _pumpSizeFromM = saved.pumpSizeFromM;
      _pumpSizeUpToM = saved.pumpSizeUpToM;
      _technician = saved.technicianRequired;
      // A technician order always starts at the documented minimum of 6.
      // Old drafts can contain 0 from before this rule existed.
      _cubeMoulds = saved.numMoulds < 6 ? 6 : saved.numMoulds;
      _temperature = saved.temperatureControl;
      _labTesting = saved.labTesting;
      _otherService = saved.otherService;
    }
    _cubeMouldController = TextEditingController(text: '$_cubeMoulds');
    _cubeMouldController.addListener(() {
      final value = int.tryParse(_cubeMouldController.text) ?? 0;
      if (value != _cubeMoulds) {
        setState(() => _cubeMoulds = value);
      }
    });
    _loadStructureTypes();
    _loadPumpTypes();
  }

  @override
  void dispose() {
    _cubeMouldController.dispose();
    super.dispose();
  }

  Future<void> _loadStructureTypes() async {
    final project = widget.draft?.project;
    if (project == null || project.projectId.isEmpty) return;
    try {
      final items = await sl<OrderApiService>().structureTypes(
        projectId: project.projectId,
        mixCode: widget.mixCode.code,
      );
      final ids = <String, String>{
        for (final item in items)
          if (item['available'] != false && item['name'] is String)
            item['name'] as String: item['id'].toString(),
      };
      final options = items
          .where((item) => item['available'] != false && item['name'] is String)
          .map(
            (item) => {
              'title': item['name'] as String,
              // API imageUrl is nullable; retain the design thumbnail when
              // the backend has no image yet.
              'image':
                  item['imageUrl'] is String &&
                      (item['imageUrl'] as String).isNotEmpty
                  ? item['imageUrl'] as String
                  : AppAssets.mixThumb4,
            },
          )
          .toList();
      if (mounted)
        setState(() {
          _structureIds = ids;
          if (options.isNotEmpty) _structureOptions = options;
          if (!ids.containsKey(_structureRef) && ids.isNotEmpty)
            _structureRef = ids.keys.first;
        });
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
    }
  }

  Future<void> _loadPumpTypes() async {
    try {
      final items = await sl<OrderApiService>().pumpTypes(
        locationId: widget.draft?.project?.locationId,
      );
      final available = items
          .where((item) => item['available'] != false)
          .toList();
      if (!mounted) return;
      setState(() {
        _pumpTypes = available;
        _pumpType ??= available.isEmpty
            ? null
            : available.first['type']?.toString();
      });
      if (_pumpType != null) await _loadPumpSizes(_pumpType!);
    } catch (_) {
      // The card remains usable only after live catalogue data is available;
      // no static pump size is sent to the v1.1 API.
    }
  }

  Future<void> _loadPumpSizes(String type) async {
    try {
      final data = await sl<OrderApiService>().pumpSizes(
        pumpType: type,
        locationId: widget.draft?.project?.locationId,
      );
      final items = (data['items'] as List? ?? const [])
          .whereType<Map>()
          .map(Map<String, dynamic>.from)
          .where((item) => item['available'] != false)
          .toList();
      if (!mounted) return;
      setState(() {
        _pumpSizes = items;
        final first = items.isEmpty
            ? null
            : (items.first['size'] as num?)?.toDouble();
        _pumpSizeFromM ??= first;
        _pumpSizeUpToM ??= items.isEmpty
            ? null
            : (items.last['size'] as num?)?.toDouble();
      });
    } catch (_) {
      if (mounted) setState(() => _pumpSizes = const []);
    }
  }

  void _onContinue() {
    if (_technician && _cubeMoulds < 6) {
      showAppSnackBar(context, 'Cube mould quantity must be at least 6.');
      return;
    }
    if (_pump &&
        (_pumpType == null ||
            _pumpSizeFromM == null ||
            _pumpSizeUpToM == null)) {
      showAppSnackBar(context, 'Choose an available pump type and size range.');
      return;
    }
    final pumpName = !_pump
        ? 'No Pump'
        : '$_pumpType (${_pumpSizeFromM!.toStringAsFixed(0)}–${_pumpSizeUpToM!.toStringAsFixed(0)} m)';

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
            structureTypeId: _structureIds[_structureRef],
            technicianRequired: _technician,
            temperatureControl: _temperature,
            pumpRequired: _pump,
            pumpName: pumpName,
            pumpType: _pump ? _pumpType : null,
            pumpSizeFromM: _pump ? _pumpSizeFromM : null,
            pumpSizeUpToM: _pump ? _pumpSizeUpToM : null,
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
                      options: _structureOptions,
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
                            'Choose pump type and reach range',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2533),
                            ),
                          ),
                          SizedBox(height: context.scaledV(10)),
                          DropdownButtonFormField<String>(
                            value:
                                _pumpTypes.any(
                                  (item) =>
                                      item['type']?.toString() == _pumpType,
                                )
                                ? _pumpType
                                : null,
                            hint: const Text('Select pump type'),
                            isExpanded: true,
                            items: _pumpTypes
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item['type']?.toString(),
                                    child: Text(item['type']?.toString() ?? ''),
                                  ),
                                )
                                .toList(),
                            onChanged: (type) async {
                              if (type == null) return;
                              setState(() {
                                _pumpType = type;
                                _pumpSizes = const [];
                                _pumpSizeFromM = null;
                                _pumpSizeUpToM = null;
                              });
                              await _loadPumpSizes(type);
                            },
                          ),
                          SizedBox(height: context.scaledV(10)),
                          Row(
                            children: [
                              Expanded(
                                child: _PumpRangeDropdown(
                                  label: 'From',
                                  value: _pumpSizeFromM,
                                  sizes: _pumpSizes,
                                  onChanged: (value) =>
                                      setState(() => _pumpSizeFromM = value),
                                ),
                              ),
                              SizedBox(width: context.scaled(8)),
                              Expanded(
                                child: _PumpRangeDropdown(
                                  label: 'Up to',
                                  value: _pumpSizeUpToM,
                                  sizes: _pumpSizes.where((item) {
                                    final size = (item['size'] as num?)
                                        ?.toDouble();
                                    return _pumpSizeFromM == null ||
                                        (size != null &&
                                            size >= _pumpSizeFromM!);
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => _pumpSizeUpToM = value),
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
                                  setState(() {
                                    _cubeMoulds--;
                                    _cubeMouldController.text = '$_cubeMoulds';
                                  });
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
                                  SizedBox(
                                    height: context.scaledV(22),
                                    width: context.scaled(42),
                                    child: TextField(
                                      controller: _cubeMouldController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: context.scaled(15),
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2533),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onEditingComplete: () {
                                        final value = int.tryParse(
                                          _cubeMouldController.text,
                                        );
                                        if (value == null || value < 6) {
                                          _cubeMouldController.text = '6';
                                          setState(() => _cubeMoulds = 6);
                                        }
                                        FocusScope.of(context).unfocus();
                                      },
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
                                setState(() {
                                  _cubeMoulds++;
                                  _cubeMouldController.text = '$_cubeMoulds';
                                });
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
  const _StructureTypeDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String value;
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;

  @override
  State<_StructureTypeDropdown> createState() => _StructureTypeDropdownState();
}

class _StructureTypeDropdownState extends State<_StructureTypeDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // The structure-types endpoint may return a value that is not part of
    // the original design-time options (or the value can briefly be empty
    // while the request is loading).  Never call firstWhere without a
    // fallback here: a missing option must not crash the whole order flow.
    final selectedItem = widget.options.firstWhere(
      (e) => e['title'] == widget.value,
      orElse: () => widget.options.isNotEmpty
          ? widget.options.first
          : _structureRefs.first,
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
                      child: (selectedItem['image'] ?? '').startsWith('http')
                          ? Image.network(
                              selectedItem['image']!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
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
            ...widget.options.map((item) {
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
                          child: (item['image'] ?? '').startsWith('http')
                              ? Image.network(item['image']!, fit: BoxFit.cover)
                              : Image.asset(item['image']!, fit: BoxFit.cover),
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
          InkWell(
            onTap: () => onToggleCheck(!isSelected),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.scaled(16)),
              bottom: isSelected && isExpanded && child != null
                  ? Radius.zero
                  : Radius.circular(context.scaled(16)),
            ),
            child: Padding(
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
                      // Expansion remains available by tapping the card;
                      // the design does not show chevrons on service cards.
                      child: SizedBox(
                        width: context.scaled(8),
                        height: context.scaled(20),
                      ),
                    ),
                  ),
                ],
              ),
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

class _PumpRangeDropdown extends StatelessWidget {
  const _PumpRangeDropdown({
    required this.label,
    required this.value,
    required this.sizes,
    required this.onChanged,
  });

  final String label;
  final double? value;
  final List<Map<String, dynamic>> sizes;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<double>(
    value: sizes.any((item) => (item['size'] as num?)?.toDouble() == value)
        ? value
        : null,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: sizes
        .map((item) {
          final size = (item['size'] as num?)?.toDouble();
          if (size == null) return null;
          return DropdownMenuItem<double>(
            value: size,
            child: Text(
              item['label']?.toString() ?? '${size.toStringAsFixed(0)} m',
            ),
          );
        })
        .whereType<DropdownMenuItem<double>>()
        .toList(),
    onChanged: onChanged,
  );
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
