import 'package:flutter/material.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/input_validators.dart';
import '../../app/navigation/app_tab_navigation.dart';
import 'order_project_summary.dart';

/// Ported from the new Figma design's `screens/AddLocation.tsx` — a map
/// band (placeholder; see `AppIllustrationPlaceholder` doc comment) plus a
/// short location/contact form. Pops with a [ProjectLocationDraft] so the
/// calling screen (`AddNewProjectScreen`) can append it to the project's
/// location list, mirroring Figma's `nav.navigate("createProject", {saved:
/// true})` round trip without a second navigation.
class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key, this.projectName});

  final String? projectName;

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addLocation() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ProjectLocationDraft(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        contactName: _contactController.text.trim(),
        contactPhone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      bottomNavigationBar: const AppTabBottomNavBar(
        currentTab: AppTab.projects,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg(context),
                  context.scaledV(8),
                  AppSpacing.lg(context),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Location',
                      style: AppTextStyles.authScreenTitle(context),
                    ),
                    if (widget.projectName != null) ...[
                      SizedBox(height: context.scaledV(4)),
                      Text.rich(
                        TextSpan(
                          text: 'For ',
                          style: AppTextStyles.cardSubtitle(context),
                          children: [
                            TextSpan(
                              text: widget.projectName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: context.scaled(13.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: context.scaledV(14)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg(context),
                ),
                child: Stack(
                  children: [
                    AppIllustrationImage(
                      asset: AppAssets.artLocationPickerMap,
                      height: 230,
                      borderRadius: 16,
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.gps_fixed_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Use current location',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg(context),
                  context.scaledV(18),
                  AppSpacing.lg(context),
                  AppSpacing.xxl(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FieldRow(
                      label: 'Location Name',
                      hint: 'e.g. Main Gate, North Entrance',
                      controller: _nameController,
                      validator: (value) =>
                          InputValidators.required(value, 'Location name'),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    _FieldRow(
                      label: 'Address',
                      hint: 'e.g. Palm Jumeirah, Frond E, Villa 123',
                      controller: _addressController,
                      validator: (value) =>
                          InputValidators.required(value, 'Address'),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _FieldRow(
                            label: 'Site Contact',
                            hint: 'e.g. Ahmed Khalid',
                            controller: _contactController,
                            validator: (value) => InputValidators.fullName(
                              value,
                              fieldName: 'Site contact',
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md(context)),
                        Expanded(
                          child: _FieldRow(
                            label: 'Mobile Number',
                            hint: '+971 50 123 4567',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: InputValidators.mobile,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(16)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.sm(context)),
                        Expanded(
                          child: Text(
                            'This pin helps ANTFAST deliver to the correct entrance.',
                            style: AppTextStyles.cardSubtitle(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(18)),
                    PrimaryButton(
                      onPressed: _addLocation,
                      label: 'Add Location',
                    ),
                    SizedBox(height: context.scaledV(10)),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x051E1946),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context.scaled(11),
              color: AppColors.textSecondary,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: context.scaled(13),
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
