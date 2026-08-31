import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/common_input_field.dart';
import '../../core/widgets/order_stepper_widget.dart';
import '../../core/widgets/primary_button.dart';
import 'new_cash_order_mix_selection_screen.dart';
import 'order_project_summary.dart';

// ── Colour palette (local, matches Figma) ──────────────────────────────────
const Color _borderSection = Color(0xFFFFFFFF);
const Color _bodyBg = Color(0xFFF5F5F5);
const Color _sheetScrim = Color(0x4D000000);
const Color _sheetBg = Colors.white;
// Exact Figma text colours
const Color _textDark = Color(0xFF1A1A1A); // titles
const Color _textGrey = Color(0xFF9E9E9E); // subtitles, labels
// Sheet / tile colours
const Color _tileBorder = Color(0xFFD3D3D3);
const Color _tileIconBg = Color(0xFFFFF8D6);
const Color _tileIconColor = Color(0xFFFF8A00);

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
    final result = await Navigator.of(context, rootNavigator: true)
        .pushNamed<OrderProjectSummary>(AppRoutes.addNewProject, arguments: true);
    if (result != null && mounted) {
      setState(() => _selectedProject = result);
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
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(24),
                    context.scaled(16),
                    context.scaled(24),
                  ),
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
                  builder: (_) => const NewCashOrderMixSelectionScreen(),
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
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaled(8),
        context.scaled(16),
        context.scaled(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button — touch target 44×44
          SizedBox(
            width: context.scaled(44),
            height: context.scaled(44),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(24)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: context.scaled(22),
            ),
          ),
          SizedBox(width: context.scaled(4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'New Cash Order',
                style: TextStyle(
                  fontSize: context.scaled(22),
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              Text(
                'Project',
                style: TextStyle(
                  fontSize: context.scaled(14),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(16),
          vertical: context.scaled(16),
        ),
        child: OrderStepperWidget(
          currentStep: currentStep,
          labels: OrderStepperWidget.flowLabels,
        ),
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
        Text(
          'Project & Site',
          style: TextStyle(
            fontSize: context.scaled(20),
            fontWeight: FontWeight.w600,
            color: _textDark,
            height: 1.2,
          ),
        ),
        SizedBox(height: context.scaledV(4)),
        Text(
          'Project Details',
          style: TextStyle(
            fontSize: context.scaled(14),
            fontWeight: FontWeight.w400,
            color: _textDark,
            height: 1.43,
          ),
        ),
        SizedBox(height: context.scaledV(24)),

        // ── Project Name field (tappable → picker) ───────────────────
        CommonInputField(
          label: 'Project Name',
          value: projectName,
          placeholder: 'Select Project',
          isRequired: true,
          trailingIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: context.scaled(24),
            color: AppColors.textPrimary,
          ),
          onTap: onProjectTap,
        ),

        SizedBox(height: context.scaledV(16)),

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
        minimum: EdgeInsets.fromLTRB(
          context.scaled(16),
          context.scaled(12),
          context.scaled(16),
          context.scaled(16),
        ),
        child: PrimaryButton(label: 'Continue', onPressed: onContinue),
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
  bool _showMap = false;
  LatLng _markerPosition = _abuDhabi;

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
    return widget.projects
        .where((p) {
          return p.projectName.toLowerCase().contains(q) ||
              p.projectSite.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 0.85,
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.scaled(20),
              context.scaled(20),
              context.scaled(20),
              bottom + context.scaled(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: context.scaled(40),
                    height: context.scaled(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6D6D6),
                      borderRadius: BorderRadius.circular(context.scaled(2)),
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(16)),

                Text(
                  'Select Project',
                  style: TextStyle(
                    fontSize: context.scaled(20),
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: context.scaledV(16)),

                // Search field
                _SearchField(controller: _search),
                SizedBox(height: context.scaledV(16)),

                // Add New Project button — reveals the inline map below
                _AddNewProjectButton(
                  onTap: () => setState(() => _showMap = true),
                ),

                // Location picker mini-section (opens with a real map once
                // "Add New Project" is tapped, instead of navigating away)
                if (_showMap) ...[
                  SizedBox(height: context.scaledV(16)),
                  _LocationPickerSection(
                    markerPosition: _markerPosition,
                    onMapTap: (pos) => setState(() => _markerPosition = pos),
                    onPinOnMap: () {
                      Navigator.of(context).pop();
                      widget.onAddNew();
                    },
                    onUseCurrentLocation: () {
                      Navigator.of(context).pop();
                      widget.onAddNew();
                    },
                  ),
                ],
                SizedBox(height: context.scaledV(20)),

                // Saved projects header
                Row(
                  children: [
                    Text(
                      'Saved Projects',
                      style: TextStyle(
                        fontSize: context.scaled(14),
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
                      child: Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: context.scaled(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.scaledV(12)),

                // Project list
                Expanded(
                  child: ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (context, idx) =>
                        SizedBox(height: context.scaledV(12)),
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

// ── Add New Project button ───────────────────────────────────────────────────

class _AddNewProjectButton extends StatelessWidget {
  const _AddNewProjectButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(context.scaled(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: context.scaled(52),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: context.scaled(20),
                color: Colors.white,
              ),
              SizedBox(width: context.scaled(8)),
              Text(
                'Add New Project',
                style: TextStyle(
                  fontSize: context.scaled(15),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Location picker mini-section ─────────────────────────────────────────────

class _LocationPickerSection extends StatelessWidget {
  const _LocationPickerSection({
    required this.markerPosition,
    required this.onMapTap,
    required this.onPinOnMap,
    required this.onUseCurrentLocation,
  });

  final LatLng markerPosition;
  final ValueChanged<LatLng> onMapTap;
  final VoidCallback onPinOnMap;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaled(10)),
      decoration: BoxDecoration(
        border: Border.all(color: _tileBorder),
        borderRadius: BorderRadius.circular(context.scaled(16)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.scaled(12)),
            child: SizedBox(
              width: double.infinity,
              height: context.scaled(180),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: markerPosition,
                  zoom: 15,
                ),
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                tiltGesturesEnabled: false,
                mapToolbarEnabled: false,
                onTap: onMapTap,
                markers: {
                  Marker(
                    markerId: const MarkerId('new-project-location'),
                    position: markerPosition,
                  ),
                },
              ),
            ),
          ),
          SizedBox(height: context.scaledV(10)),
          _LocationOptionRow(
            icon: Icons.location_on_outlined,
            label: 'Pin Location on Map',
            onTap: onPinOnMap,
          ),
          SizedBox(height: context.scaledV(8)),
          _LocationOptionRow(
            icon: Icons.navigation_outlined,
            label: 'Use Current Location',
            onTap: onUseCurrentLocation,
          ),
        ],
      ),
    );
  }
}

class _LocationOptionRow extends StatelessWidget {
  const _LocationOptionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: context.scaled(14),
            vertical: context.scaledV(14),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: _tileBorder),
            borderRadius: BorderRadius.circular(context.scaled(12)),
          ),
          child: Row(
            children: [
              Icon(icon, size: context.scaled(18), color: AppColors.primary),
              SizedBox(width: context.scaled(10)),
              Text(
                label,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
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
      height: context.scaled(48),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: context.scaled(14),
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search existing projects',
          hintStyle: TextStyle(fontSize: context.scaled(14), color: _textGrey),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: context.scaled(20),
            color: AppColors.textPrimary,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.scaled(16),
            vertical: 0,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.scaled(12)),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.scaled(12)),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.scaled(12)),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
      borderRadius: BorderRadius.circular(context.scaled(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.scaled(16)),
            border: Border.all(
              color: isSelected ? AppColors.primary : _tileBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.scaled(12)),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: context.scaled(44),
                  height: context.scaled(44),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tileIconBg,
                    borderRadius: BorderRadius.circular(context.scaled(12)),
                  ),
                  child: Icon(
                    Icons.apartment_rounded,
                    size: context.scaled(24),
                    color: _tileIconColor,
                  ),
                ),
                SizedBox(width: context.scaled(12)),
                // Name + site
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName,
                        style: TextStyle(
                          fontSize: context.scaled(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: context.scaledV(2)),
                      Text(
                        project.projectSite,
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          fontWeight: FontWeight.w400,
                          color: _textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: context.scaled(8)),
                  Icon(
                    Icons.check_circle_rounded,
                    size: context.scaled(20),
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
