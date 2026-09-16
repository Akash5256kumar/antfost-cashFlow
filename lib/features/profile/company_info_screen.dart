import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/input_validators.dart';
import '../../app/di/injection.dart';
import '../../core/services/company_api_service.dart';

class CompanyInfoScreen extends StatefulWidget {
  const CompanyInfoScreen({super.key});

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  String? _loadError;
  String? _kycStatus;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _legalNameController;
  late TextEditingController _tradeNameController;
  late TextEditingController _licenseNoController;
  late TextEditingController _trnController;
  late TextEditingController _industryController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _legalNameController = TextEditingController();
    _tradeNameController = TextEditingController();
    _licenseNoController = TextEditingController();
    _trnController = TextEditingController();
    _industryController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    try {
      final d = await sl<CompanyApiService>().getCompany();
      if (!mounted) return;
      setState(() {
        _legalNameController.text = d['legalName'] as String? ?? '';
        _tradeNameController.text = d['tradeName'] as String? ?? '';
        _licenseNoController.text = d['tradeLicenseNumber'] as String? ?? '';
        _trnController.text = d['trn'] as String? ?? '';
        _industryController.text = d['industry'] as String? ?? '';
        _addressController.text = d['officeAddress'] as String? ?? '';
        _emailController.text = d['officialEmail'] as String? ?? '';
        _phoneController.text = d['corporatePhone'] as String? ?? '';
        _websiteController.text = d['website'] as String? ?? '';
        _kycStatus = d['kyc']?.toString().toLowerCase();
        _isLoading = false;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  String get _kycLabel => switch (_kycStatus) {
    'approved' => 'KYC Verified Business Account',
    'under_review' || 'pending' => 'KYC Under Review',
    'partially_submitted' => 'KYC Details Required',
    'rejected' => 'KYC Action Required',
    _ => 'KYC Not Submitted',
  };

  IconData get _kycIcon => switch (_kycStatus) {
    'approved' => Icons.verified_rounded,
    'under_review' || 'pending' => Icons.hourglass_top_rounded,
    'rejected' => Icons.error_outline_rounded,
    _ => Icons.info_outline_rounded,
  };

  Color get _kycIconColor => switch (_kycStatus) {
    'approved' => const Color(0xFF6EE7B7),
    'under_review' || 'pending' => const Color(0xFFFFD166),
    'rejected' => const Color(0xFFFFA3A3),
    _ => const Color(0xFFB9C6FF),
  };

  @override
  void dispose() {
    _legalNameController.dispose();
    _tradeNameController.dispose();
    _licenseNoController.dispose();
    _trnController.dispose();
    _industryController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await sl<CompanyApiService>().saveCompany({
          'legalName': _legalNameController.text.trim(),
          'tradeName': _tradeNameController.text.trim(),
          'tradeLicenseNumber': _licenseNoController.text.trim(),
          'trn': _trnController.text.trim(),
          'industry': _industryController.text.trim(),
          'officeAddress': _addressController.text.trim(),
          'officialEmail': _emailController.text.trim(),
          'corporatePhone': _phoneController.text.trim(),
          'website': _websiteController.text.trim(),
        });
        if (!mounted) return;
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company information updated successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Company Info',
          style: TextStyle(
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading || _loadError != null
                ? null
                : () {
                    if (_isEditing) {
                      _saveChanges();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
            child: Text(
              _isEditing ? 'Done' : 'Edit',
              style: TextStyle(
                fontSize: context.scaled(15),
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? _CompanyLoadError(
                message: _loadError!,
                onRetry: () {
                  setState(() {
                    _isLoading = true;
                    _loadError = null;
                  });
                  _loadCompany();
                },
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.scaled(16)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Badge Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(context.scaled(18)),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, Color(0xFF8B80FF)],
                          ),
                          borderRadius: BorderRadius.circular(
                            context.scaled(18),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: context.scaled(56),
                              height: context.scaled(56),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  context.scaled(14),
                                ),
                              ),
                              child: Icon(
                                Icons.apartment_rounded,
                                size: context.scaled(32),
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: context.scaled(14)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _legalNameController.text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: context.scaled(17),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(4)),
                                  Row(
                                    children: [
                                      Icon(
                                        _kycIcon,
                                        size: 16,
                                        color: _kycIconColor,
                                      ),
                                      SizedBox(width: context.scaled(4)),
                                      Expanded(
                                        child: Text(
                                          _kycLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: context.scaled(12),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // Legal & Tax Identification
                      _buildSectionHeader('Legal & Tax Registration'),
                      SizedBox(height: context.scaledV(10)),
                      Container(
                        padding: EdgeInsets.all(context.scaled(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            context.scaled(18),
                          ),
                          border: Border.all(color: const Color(0xFFEAEAEA)),
                        ),
                        child: Column(
                          children: [
                            _buildInfoField(
                              label: 'Legal Entity Name',
                              controller: _legalNameController,
                              icon: Icons.business_rounded,
                              isEditing: _isEditing,
                              validator: (value) => InputValidators.fullName(
                                value,
                                fieldName: 'Legal entity name',
                              ),
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Commercial Trade Name',
                              controller: _tradeNameController,
                              icon: Icons.storefront_rounded,
                              isEditing: _isEditing,
                              validator: (value) => InputValidators.fullName(
                                value,
                                fieldName: 'Commercial trade name',
                              ),
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Trade License Number',
                              controller: _licenseNoController,
                              icon: Icons.assignment_outlined,
                              isEditing: _isEditing,
                              validator: (value) =>
                                  InputValidators.tradeRegistration(
                                    value,
                                    'Trade license number',
                                  ),
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Tax Registration Number (TRN / VAT)',
                              controller: _trnController,
                              icon: Icons.receipt_long_outlined,
                              isEditing: _isEditing,
                              validator: InputValidators.trn,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // Corporate Contact Details
                      _buildSectionHeader('Contact & Headquarters Address'),
                      SizedBox(height: context.scaledV(10)),
                      Container(
                        padding: EdgeInsets.all(context.scaled(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            context.scaled(18),
                          ),
                          border: Border.all(color: const Color(0xFFEAEAEA)),
                        ),
                        child: Column(
                          children: [
                            _buildInfoField(
                              label: 'Office Address',
                              controller: _addressController,
                              icon: Icons.location_on_outlined,
                              isEditing: _isEditing,
                              validator: (value) => InputValidators.required(
                                value,
                                'Office address',
                              ),
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Official Email',
                              controller: _emailController,
                              icon: Icons.mail_outline_rounded,
                              isEditing: _isEditing,
                              validator: InputValidators.email,
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Corporate Landline Phone',
                              controller: _phoneController,
                              icon: Icons.phone_outlined,
                              isEditing: _isEditing,
                              validator: InputValidators.phone,
                            ),
                            _divider(),
                            _buildInfoField(
                              label: 'Company Website',
                              controller: _websiteController,
                              icon: Icons.language_rounded,
                              isEditing: _isEditing,
                              validator: InputValidators.website,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.scaledV(20)),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: _isEditing
          ? SafeArea(
              top: false,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  context.scaledV(12),
                  context.scaled(16),
                  context.scaledV(16),
                ),
                child: PrimaryButton(
                  label: 'Save Company Information',
                  onPressed: _saveChanges,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.scaled(15),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: Color(0xFFEFEFEF)),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    String? Function(String?)? validator,
  }) {
    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextFormField(
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: context.scaled(14),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: const Color(0xFFF9F9FB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: const Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.text,
                  style: TextStyle(
                    fontSize: context.scaled(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyLoadError extends StatelessWidget {
  const _CompanyLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
