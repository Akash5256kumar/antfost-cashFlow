import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/common_input_field.dart';
import '../../core/widgets/order_stepper_widget.dart';
import '../../core/widgets/primary_button.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'order_project_summary.dart';

// ── Colour palette (local, matches Figma) ──────────────────────────────────
const Color _borderSection   = Color(0xFFEFEFEF);
const Color _bodyBg          = Color(0xFFF2F2F7);
const Color _sheetScrim      = Color(0x4D000000);
const Color _sheetBg         = Colors.white;
// Exact Figma text colours
const Color _textDark        = Color(0xFF1A1A1A);  // titles
const Color _textGrey        = Color(0xFF9E9E9E);  // subtitles, labels
// Sheet / tile colours
const Color _tileBorder      = Color(0xFFE3E3E3);
const Color _tileIconBg      = Color(0xFFFFF8D6);
const Color _tileIconColor   = Color(0xFFFF8A00);

// ── Sample data ────────────────────────────────────────────────────────────
const _abuDhabi = LatLng(24.48862, 54.38652);
const _dubaiMarina = LatLng(25.08179, 55.13809);
const _palmPin = LatLng(25.11237, 55.13843);

// ── Screen ─────────────────────────────────────────────────────────────────

class NewCashOrderScreen extends StatefulWidget {
  const NewCashOrderScreen({super.key});

  @override
  State<NewCashOrderScreen> createState() => _NewCashOrderScreenState();
}

class _NewCashOrderScreenState extends State<NewCashOrderScreen> {
  // Step index is 0-based; Step 1 → index 0
  static const int _currentStep = 0;

  static const List<OrderProjectSummary> _savedProjects = [
    OrderProjectSummary(
      projectName: 'Al Reef Villas - Phase 2',
      projectSite: 'Block A - Foundation (Abu Dhabi)',
      locationLabel: 'Al Reef Villas - Abu Dhabi',
      coordinates: _abuDhabi,
    ),
    OrderProjectSummary(
      projectName: 'Dubai Marina Tower',
      projectSite: 'Block B - Columns (Dubai)',
      locationLabel: 'Dubai Marina - Dubai',
      coordinates: _dubaiMarina,
    ),
    OrderProjectSummary(
      projectName: 'Palm Jumeirah Residences',
      projectSite: 'Block C - Slabs (Dubai)',
      locationLabel: 'Palm Jumeirah - Dubai',
      coordinates: _palmPin,
    ),
  ];

  OrderProjectSummary? _selectedProject;

  // ── Derived display values ────────────────────────────────────────────
  String? get _projectName => _selectedProject?.projectName;
  String? get _projectSite => _selectedProject?.projectSite;

  // ── Actions ──────────────────────────────────────────────────────────
  Future<void> _openProjectPicker() async {
    final result = await showModalBottomSheet<OrderProjectSummary?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: _sheetScrim,
      builder: (_) => _ProjectPickerSheet(
        projects: _savedProjects,
        selectedProject: _selectedProject,
        onAddNew: _openAddNewProject,
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _selectedProject = result);
  }

  Future<void> _openAddNewProject() async {
    final created = await Navigator.of(context)
        .pushNamed<OrderProjectSummary>(AppRoutes.addNewProject);
    if (created != null && mounted) {
      setState(() => _selectedProject = created);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ───────────────────────────────────────────────
            _AppBar(),

            // ── Stepper (white zone, bordered top + bottom) ───────────
            _StepperSection(currentStep: _currentStep),

            // ── Scrollable body (grey background) ─────────────────────
            Expanded(
              child: Container(
                color: _bodyBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: _ProjectSiteForm(
                    projectName: _projectName,
                    projectSite: _projectSite,
                    onProjectTap: _openProjectPicker,
                  ),
                ),
              ),
            ),

            // ── Bottom CTA (white card shadow above body) ──────────────
            _BottomBar(
              onContinue: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NewCashOrderMixCodeScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Bar ─────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button — touch target 44×44
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'New Cash Order',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Project',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stepper section ──────────────────────────────────────────────────────────

class _StepperSection extends StatelessWidget {
  const _StepperSection({required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: _borderSection, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: OrderStepperWidget(currentStep: currentStep),
      ),
    );
  }
}

// ── "Project & Site" form ────────────────────────────────────────────────────

class _ProjectSiteForm extends StatelessWidget {
  const _ProjectSiteForm({
    required this.projectName,
    required this.projectSite,
    required this.onProjectTap,
  });

  final String? projectName;
  final String? projectSite;
  final VoidCallback onProjectTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        const Text(
          'Project & Site',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _textDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Project Details',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _textGrey,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 24),

        // ── Project Name field (tappable → picker) ───────────────────
        CommonInputField(
          label: 'Project Name',
          value: projectName,
          placeholder: 'Select Project',
          isRequired: true,
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: AppColors.textPrimary,
          ),
          onTap: onProjectTap,
        ),

        const SizedBox(height: 16),

        // ── Project Site field (read-only, populated from project) ────
        CommonInputField(
          label: 'Project Site',
          value: projectSite,
          placeholder: 'Block A - Foundation (Abu Dhabi)',
          isRequired: true,
        ),
      ],
    );
  }
}

// ── Bottom CTA bar ───────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderSection, width: 1)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: PrimaryButton(
          label: 'Continue',
          onPressed: onContinue,
        ),
      ),
    );
  }
}

// ── Project picker bottom sheet ──────────────────────────────────────────────

class _ProjectPickerSheet extends StatefulWidget {
  const _ProjectPickerSheet({
    required this.projects,
    required this.selectedProject,
    required this.onAddNew,
  });

  final List<OrderProjectSummary> projects;
  final OrderProjectSummary? selectedProject;
  final Future<void> Function() onAddNew;

  @override
  State<_ProjectPickerSheet> createState() => _ProjectPickerSheetState();
}

class _ProjectPickerSheetState extends State<_ProjectPickerSheet> {
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

  List<OrderProjectSummary> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return widget.projects;
    return widget.projects.where((p) {
      return p.projectName.toLowerCase().contains(q) ||
          p.projectSite.toLowerCase().contains(q);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 0.55,
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(20, 20, 20, bottom + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
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

                const Text(
                  'Select Project',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Search field
                _SearchField(controller: _search),
                const SizedBox(height: 20),

                // Saved projects header
                Row(
                  children: [
                    const Text(
                      'Saved Projects',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textGrey,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onAddNew();
                      },
                      child: const Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Project list
                Expanded(
                  child: ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (context, idx) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = _filtered[i];
                      return _ProjectTile(
                        project: p,
                        isSelected: p == widget.selectedProject,
                        onTap: () => Navigator.of(context).pop(p),
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

// ── Search field ─────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(fontSize: 14, color: _textGrey),
          prefixIcon: const Icon(Icons.search_rounded,
              size: 20, color: AppColors.textPrimary),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Project tile ─────────────────────────────────────────────────────────────

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  final OrderProjectSummary project;
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : _tileBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tileIconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    size: 24,
                    color: _tileIconColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Name + site
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        project.projectSite,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_rounded,
                      size: 20, color: AppColors.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
