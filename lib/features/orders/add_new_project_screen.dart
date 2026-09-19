import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../app/di/injection.dart';
import '../../features/profile/saved_sites_screen.dart';
import 'add_location_screen.dart';
import 'order_project_summary.dart';
import 'new_cash_order_draft.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'presentation/bloc/add_new_project_bloc.dart';
import 'presentation/bloc/add_new_project_event.dart';
import 'presentation/bloc/add_new_project_state.dart';

IconData _getIconForType(String value) {
  switch (value.toLowerCase()) {
    case 'residential':
      return Icons.home_rounded;
    case 'commercial':
      return Icons.apartment_rounded;
    case 'industrial':
      return Icons.factory_rounded;
    case 'infrastructure':
      return Icons.alt_route_rounded;
    default:
      return Icons.business_rounded;
  }
}

class AddNewProjectScreen extends StatelessWidget {
  const AddNewProjectScreen({super.key, this.returnResult = false});

  final bool returnResult;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddNewProjectBloc>()..add(const LoadProjectTypesEvent()),
      child: _AddNewProjectScreenView(returnResult: returnResult),
    );
  }
}

class _AddNewProjectScreenView extends StatefulWidget {
  const _AddNewProjectScreenView({required this.returnResult});

  final bool returnResult;

  @override
  State<_AddNewProjectScreenView> createState() => _AddNewProjectScreenViewState();
}

class _AddNewProjectScreenViewState extends State<_AddNewProjectScreenView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      context.read<AddNewProjectBloc>().add(ProjectNameChangedEvent(_nameController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addLocation(AddNewProjectState state) async {
    if (!_formKey.currentState!.validate()) return;
    if (state.selectedType == null) {
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

    context.read<AddNewProjectBloc>().add(LocationAddedEvent(result));
  }

  void _createOrder(AddNewProjectState state) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AddNewProjectBloc>().add(const SubmitProjectEvent());
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTitleHeader(title: 'New Project'),
      body: BlocListener<AddNewProjectBloc, AddNewProjectState>(
        listener: (context, state) {
          if (state.status == AddNewProjectStatus.failure) {
            _showValidationMessage(state.errorMessage ?? 'An error occurred.');
          } else if (state.status == AddNewProjectStatus.success && state.createdProject != null) {
            final created = state.createdProject!;
            final firstLocation = state.locations.first;
            final serverLocation = created.locations.isEmpty ? null : created.locations.first;
            if (serverLocation == null || serverLocation.id.isEmpty) {
              _showValidationMessage('Project was saved without a location ID.');
              return;
            }
            final summary = OrderProjectSummary(
              projectId: created.id,
              locationId: serverLocation.id,
              projectName: state.projectName.trim().isEmpty ? 'New Project' : state.projectName.trim(),
              projectSite: state.selectedType ?? 'Residential',
              locationLabel: firstLocation.address,
              coordinates: LatLng(firstLocation.latitude, firstLocation.longitude),
            );

            if (widget.returnResult) {
              Navigator.of(context).pop(summary);
            } else {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => NewCashOrderMixCodeScreen(
                    draft: NewCashOrderDraft(project: summary),
                  ),
                ),
              );
            }
          }
        },
        child: BlocBuilder<AddNewProjectBloc, AddNewProjectState>(
          builder: (context, state) {
            final hasLocations = state.locations.isNotEmpty;
            final isSaving = state.status == AddNewProjectStatus.saving;
            final isLocationReady = state.isLocationReady;
            final isLoadingTypes = state.status == AddNewProjectStatus.initial ||
                state.status == AddNewProjectStatus.loadingTypes;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasLocations) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded, size: 15, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Your project has been saved',
                              style: AppTextStyles.badgeLabel(context).copyWith(color: AppColors.primary),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                            child: const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) => InputValidators.fullName(value, fieldName: 'Project name'),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              style: TextStyle(
                                fontSize: context.scaled(13),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Project Name',
                                hintText: 'Enter your project name',
                                hintStyle: TextStyle(
                                  fontSize: context.scaled(13),
                                  color: AppColors.iconMuted,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: context.scaled(13),
                                  color: AppColors.textSecondary,
                                ),
                                floatingLabelStyle: TextStyle(
                                  fontSize: context.scaled(11),
                                  color: AppColors.textSecondary,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(10)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                            child: const Icon(Icons.layers_rounded, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: isLoadingTypes
                                ? DropdownButtonFormField<String>(
                                    value: null,
                                    decoration: InputDecoration(
                                      labelText: 'Project Type',
                                      labelStyle: TextStyle(
                                        fontSize: context.scaled(13),
                                        color: AppColors.textSecondary,
                                      ),
                                      floatingLabelStyle: TextStyle(
                                        fontSize: context.scaled(11),
                                        color: AppColors.textSecondary,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    hint: Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontSize: context.scaled(13),
                                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    icon: const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    items: const [],
                                    onChanged: null,
                                  )
                                : DropdownButtonFormField<String>(
                                    value: state.selectedType,
                                    decoration: InputDecoration(
                                      labelText: 'Project Type',
                                      labelStyle: TextStyle(
                                        fontSize: context.scaled(13),
                                        color: AppColors.textSecondary,
                                      ),
                                      floatingLabelStyle: TextStyle(
                                        fontSize: context.scaled(11),
                                        color: AppColors.textSecondary,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    hint: Text(
                                      'Select type',
                                      style: TextStyle(
                                        fontSize: context.scaled(13),
                                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.iconMuted),
                                    items: state.projectTypes.map((t) {
                                      return DropdownMenuItem<String>(
                                        value: t.value,
                                        child: Row(
                                          children: [
                                            Icon(_getIconForType(t.value), size: 19, color: AppColors.primary),
                                            const SizedBox(width: 12),
                                            Text(
                                              t.name,
                                              style: TextStyle(
                                                fontSize: context.scaled(13),
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        context.read<AddNewProjectBloc>().add(ProjectTypeChangedEvent(val));
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(18)),
                    if (hasLocations) ...[
                      Text('Project Locations', style: AppTextStyles.cardTitle(context)),
                      Text(
                        'Add one or more delivery locations to this project.',
                        style: AppTextStyles.cardSubtitle(context),
                      ),
                      SizedBox(height: context.scaledV(10)),
                      ...state.locations.map(
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
                                  child: const Icon(Icons.location_on_rounded, size: 19, color: AppColors.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.name,
                                        style: AppTextStyles.cardTitle(context).copyWith(fontSize: context.scaled(14)),
                                      ),
                                      if (loc.address.isNotEmpty)
                                        Text(loc.address, style: AppTextStyles.cardSubtitle(context)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        onPressed: isLocationReady ? () => _addLocation(state) : null,
                        variant: PrimaryButtonVariant.outline,
                        label: 'Add Another Location',
                        icon: const Icon(Icons.add, size: 18),
                      ),
                      SizedBox(height: context.scaledV(14)),
                      PrimaryButton(
                        onPressed: isSaving ? null : () => _createOrder(state),
                        arrow: true,
                        label: isSaving ? 'Saving Project…' : 'Create New Order',
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
                                child: const Icon(Icons.location_on_outlined, size: 22, color: AppColors.primary),
                              ),
                              SizedBox(height: context.scaledV(10)),
                              Text('No locations added', style: AppTextStyles.cardTitle(context)),
                              Text(
                                'Add the first delivery location for this project.',
                                style: AppTextStyles.cardSubtitle(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(14)),
                      PrimaryButton(
                        onPressed: isLocationReady ? () => _addLocation(state) : null,
                        label: 'Add Location',
                        icon: const Icon(Icons.add, size: 20),
                      ),
                      SizedBox(height: context.scaledV(10)),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final result = await Navigator.of(context).push<ProjectLocationDraft>(
                              MaterialPageRoute(
                                builder: (_) => const SavedSitesScreen(pickForProject: true),
                              ),
                            );
                            if (result != null && mounted) {
                              context.read<AddNewProjectBloc>().add(LocationAddedEvent(result));
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
            );
          },
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
    required this.strokeWidth,
    required this.dashSpace,
    required this.dashWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
      distance = 0.0; // Reset for the next metric
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
