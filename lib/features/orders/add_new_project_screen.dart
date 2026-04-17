import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import 'order_project_summary.dart';

// ── Figma colour tokens (local) ────────────────────────────────────────────
const Color _textDark      = Color(0xFF1A1A1A);
const Color _textGrey      = Color(0xFF9E9E9E);
const Color _labelGrey     = Color(0xFF9F9DA6);
const Color _requiredPink  = Color(0xFFFF5CA8);
const Color _fieldBorder   = Color(0xFFD7D7D7);
const Color _searchBorder  = Color(0xFF111111);

class AddNewProjectScreen extends StatefulWidget {
  const AddNewProjectScreen({super.key});

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  static const LatLng _initialLocation = LatLng(24.48862, 54.38652);
  static const CameraPosition _initialCamera = CameraPosition(
    target: _initialLocation,
    zoom: 16.7,
  );

  final TextEditingController _searchController    = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController(
    text: 'Al Reef Villas - Phase 2',
  );
  final TextEditingController _projectSiteController = TextEditingController(
    text: 'Block A - Foundation',
  );
  final TextEditingController _projectLocationController = TextEditingController();

  LatLng _markerPosition = _initialLocation;

  @override
  void dispose() {
    _searchController.dispose();
    _projectNameController.dispose();
    _projectSiteController.dispose();
    _projectLocationController.dispose();
    super.dispose();
  }

  void _handleMapTap(LatLng position) =>
      setState(() => _markerPosition = position);

  void _saveProject() {
    Navigator.of(context).pop(
      OrderProjectSummary(
        projectName: _projectNameController.text.trim().isEmpty
            ? 'Al Reef Villas - Phase 2'
            : _projectNameController.text.trim(),
        projectSite: _projectSiteController.text.trim().isEmpty
            ? 'Block A - Foundation'
            : _projectSiteController.text.trim(),
        locationLabel: _projectLocationController.text.trim().isEmpty
            ? 'Pinned Project Location'
            : _projectLocationController.text.trim(),
        coordinates: _markerPosition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────
            _AppBar(),

            // ── Map + overlays + bottom panel ─────────────────────────
            Expanded(
              child: Stack(
                children: [
                  // Full-screen map
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: _initialCamera,
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      onTap: _handleMapTap,
                      markers: {
                        Marker(
                          markerId: const MarkerId('project-location'),
                          position: _markerPosition,
                        ),
                      },
                    ),
                  ),

                  // Search bar overlay
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 16,
                    child: _MapSearchBar(controller: _searchController),
                  ),

                  // Bottom details panel
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _ProjectDetailsPanel(
                      projectNameController: _projectNameController,
                      projectSiteController: _projectSiteController,
                      projectLocationController: _projectLocationController,
                      onSave: _saveProject,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Add New Project',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Create a new Project',
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

// ── Map search bar ───────────────────────────────────────────────────────────

class _MapSearchBar extends StatelessWidget {
  const _MapSearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _searchBorder, width: 1.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search_rounded, size: 22, color: _textDark),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _textDark,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _labelGrey,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

// ── Bottom details panel ─────────────────────────────────────────────────────

class _ProjectDetailsPanel extends StatelessWidget {
  const _ProjectDetailsPanel({
    required this.projectNameController,
    required this.projectSiteController,
    required this.projectLocationController,
    required this.onSave,
  });

  final TextEditingController projectNameController;
  final TextEditingController projectSiteController;
  final TextEditingController projectLocationController;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section heading
                const Text(
                  'Project Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),

                // Project Name
                _InputField(
                  label: 'Project Name',
                  controller: projectNameController,
                  isRequired: true,
                ),
                const SizedBox(height: 16),

                // Project Site Name
                _InputField(
                  label: 'Project Site Name',
                  controller: projectSiteController,
                  isRequired: true,
                ),
                const SizedBox(height: 16),

                // Project Location
                _InputField(
                  label: 'Project Loaction',
                  controller: projectLocationController,
                  isRequired: true,
                  hintText: 'Enter or Pin Project Location',
                ),
                const SizedBox(height: 20),

                // Save & Continue button
                PrimaryButton(
                  label: 'Save & Continue',
                  onPressed: onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Input field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _labelGrey,
                height: 1.33,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: '*',
                    style: TextStyle(color: _requiredPink),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: _textDark,
              height: 1.25,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _labelGrey,
                height: 1.25,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
