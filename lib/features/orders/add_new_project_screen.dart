import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/input_validators.dart';
import '../../core/services/project_location_api_service.dart';
import '../../core/errors/exceptions.dart';
import '../../app/di/injection.dart';
import '../../features/profile/saved_sites_screen.dart';
import 'add_location_screen.dart';
import 'order_project_summary.dart';
import 'new_cash_order_draft.dart';
import 'new_cash_order_mix_code_screen.dart';

const List<_ProjectType> _projectTypes = [
  _ProjectType('Residential', Icons.home_rounded),
  _ProjectType('Commercial', Icons.apartment_rounded),
  _ProjectType('Industrial', Icons.factory_rounded),
  _ProjectType('Infrastructure', Icons.alt_route_rounded),
];

class _ProjectType {
  const _ProjectType(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Ported from the new Figma design's `screens/CreateProject.tsx`. The map
/// picker Figma places on `AddLocation` now lives on [AddLocationScreen];
/// this screen owns project metadata (name/type) and its location list,
/// updating in place when a location is added rather than round-tripping
/// through `nav.navigate` params the way the Figma prototype does.
///
/// Pops with an [OrderProjectSummary] once the user has at least one
/// location and taps "Create New Order", preserving the existing contract
/// `SavedSitesScreen` relies on when adding a project from Profile.
class AddNewProjectScreen extends StatefulWidget {
  const AddNewProjectScreen({super.key, this.returnResult = false});

  final bool returnResult;

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedType;
  bool _typeExpanded = true;
  final List<ProjectLocationDraft> _locations = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addLocation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      _showValidationMessage('Select a project type before adding a location.');
      return;
    }
    final result = await Navigator.of(context).push<ProjectLocationDraft>(
      MaterialPageRoute(
        builder: (_) => AddLocationScreen(
          projectName: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
        ),
      ),
    );
    if (result == null || !mounted) return;

    setState(() => _locations.add(result));
  }

  bool _isSaving = false;

  Future<void> _createOrder([ProjectLocationDraft? location]) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      _showValidationMessage('Select a project type to continue.');
      return;
    }
    if (location == null && _locations.isEmpty) {
      _showValidationMessage('Add at least one delivery location to continue.');
      return;
    }
    final locations = location == null ? _locations : [..._locations, location];
    setState(() => _isSaving = true);
    try {
      final created = await sl<ProjectLocationApiService>().createProject(
        name: _nameController.text.trim(),
        projectType: _selectedType!,
        locations: locations
            .map(
              (item) => ProjectLocationPayload(
                name: item.name,
                address: item.address,
                latitude: item.latitude,
                longitude: item.longitude,
                contactName: item.contactName ?? '',
                contactPhone: item.contactPhone ?? '',
              ),
            )
            .toList(),
      );
      if (!mounted) return;
      final firstLocation = locations.first;
      final serverLocation = created.locations.isEmpty
          ? null
          : created.locations.first;
      if (serverLocation == null || serverLocation.id.isEmpty) {
        throw const FormatException('Project was saved without a location ID.');
      }
      final summary = OrderProjectSummary(
        projectId: created.id,
        locationId: serverLocation.id,
        projectName: _nameController.text.trim().isEmpty
            ? 'New Project'
            : _nameController.text.trim(),
        projectSite: _selectedType ?? 'Residential',
        locationLabel: firstLocation.address,
        coordinates: LatLng(firstLocation.latitude, firstLocation.longitude),
      );

      if (widget.returnResult) {
        Navigator.of(context).pop(summary);
      } else {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => NewCashOrderMixCodeScreen(
              draft: NewCashOrderDraft(project: summary),
            ),
          ),
        );
      }
    } on ServerException catch (error) {
      _showValidationMessage(error.message);
    } on NetworkException catch (error) {
      _showValidationMessage(error.message);
    } on TimeoutException catch (error) {
      _showValidationMessage(error.message);
    } on Exception catch (error) {
      _showValidationMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasLocations = _locations.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTitleHeader(title: 'New Project'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasLocations) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Your project has been saved',
                        style: AppTextStyles.badgeLabel(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.scaledV(10)),
              ],
              Text(
                'Create New Project',
                style: AppTextStyles.authScreenTitle(context),
              ),
              SizedBox(height: context.scaledV(4)),
              Text(
                'Set up your project, then add its delivery locations.',
                style: AppTextStyles.cardSubtitle(context),
              ),
              SizedBox(height: context.scaledV(12)),
              AppIllustrationImage(
                asset: AppAssets.artProjectBuild,
                height: 170,
                borderRadius: 0,
                fit: BoxFit.contain,
              ),
              SizedBox(height: context.scaledV(14)),
              Text('Project Details', style: AppTextStyles.cardTitle(context)),
              SizedBox(height: context.scaledV(10)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Project Name',
                            style: TextStyle(
                              fontSize: context.scaled(11),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) => InputValidators.fullName(
                              value,
                              fieldName: 'Project name',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.scaledV(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          setState(() => _typeExpanded = !_typeExpanded),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.layers_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Project Type',
                                    style: TextStyle(
                                      fontSize: context.scaled(11),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _selectedType ?? 'Select type',
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _typeExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.iconMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_typeExpanded)
                      Column(
                        children: _projectTypes.map((t) {
                          final on = t.label == _selectedType;
                          return InkWell(
                            onTap: () =>
                                setState(() => _selectedType = t.label),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.cardBorder),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    t.icon,
                                    size: 19,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      t.label,
                                      style: TextStyle(
                                        fontSize: context.scaled(13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: on
                                            ? AppColors.primary
                                            : const Color(0xFFD3D1E4),
                                        width: 2,
                                      ),
                                    ),
                                    child: on
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              SizedBox(height: context.scaledV(18)),
              if (hasLocations) ...[
                Text(
                  'Project Locations',
                  style: AppTextStyles.cardTitle(context),
                ),
                Text(
                  'Add one or more delivery locations to this project.',
                  style: AppTextStyles.cardSubtitle(context),
                ),
                SizedBox(height: context.scaledV(10)),
                ..._locations.map(
                  (loc) => Padding(
                    padding: EdgeInsets.only(bottom: context.scaledV(10)),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.muted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.location_on_rounded,
                              size: 19,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.name,
                                  style: AppTextStyles.cardTitle(
                                    context,
                                  ).copyWith(fontSize: context.scaled(14)),
                                ),
                                if (loc.address.isNotEmpty)
                                  Text(
                                    loc.address,
                                    style: AppTextStyles.cardSubtitle(context),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _addLocation,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Another Location'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(14)),
                PrimaryButton(
                  onPressed: _isSaving ? null : _createOrder,
                  arrow: true,
                  label: _isSaving ? 'Saving Project…' : 'Create New Order',
                ),
              ] else ...[
                CustomPaint(
                  painter: _DashedRectPainter(
                    color: AppColors.cardBorder,
                    strokeWidth: 1.5,
                    dashSpace: 6,
                    dashWidth: 6,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.location_on_outlined,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: context.scaledV(10)),
                        Text(
                          'No locations added',
                          style: AppTextStyles.cardTitle(context),
                        ),
                        Text(
                          'Add the first delivery location for this project.',
                          style: AppTextStyles.cardSubtitle(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(14)),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Location',
                          style: TextStyle(
                            fontSize: context.scaled(15),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.add, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(10)),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      final result = await Navigator.of(context)
                          .push<ProjectLocationDraft>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SavedSitesScreen(pickForProject: true),
                            ),
                          );
                      if (result != null) {
                        setState(() {
                          _locations.add(result);
                        });
                      }
                    },
                    child: Text(
                      'Use a saved location instead',
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashSpace;
  final double dashWidth;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashSpace = 4.0,
    this.dashWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    final dashPath = Path();
    var distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0; // Reset for next contour if any
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.dashWidth != dashWidth;
  }
}
