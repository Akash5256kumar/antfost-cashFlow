import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/di/injection.dart';
import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/app_svg_icons.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/uploads/document_picker_service.dart';
import '../../core/services/document_api_service.dart';
import '../../core/services/api_client.dart';
import '../../core/utils/input_validators.dart';
import '../../core/utils/route_feedback.dart';
import 'presentation/bloc/kyc_bloc.dart';
import 'presentation/bloc/kyc_event.dart';

/// Ported from the new Figma design's `screens/VerifyBusiness.tsx`. The
/// Business accounts reach this screen after OTP verification. Individual
/// accounts continue directly to Home.
class KycVerificationScreen extends StatefulWidget {
  final bool isBusiness;

  const KycVerificationScreen({super.key, this.isBusiness = true});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _legalNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final Map<String, SelectedDocument> _documents = {};
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // The login response asked the customer to complete KYC. Load the latest
    // server state immediately, including any document status from an earlier
    // attempt, instead of treating this page as a local-only form.
    context.read<KycBloc>().add(const FetchKycStatusEvent());
    if (widget.isBusiness) _loadCompanyDetails();
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanyDetails() async {
    try {
      final response = await sl<ApiClient>().get<Map<String, dynamic>>(
        '/kyc/company-details',
      );
      final fields = response.data?['fields'];
      if (!mounted || fields is! Map) return;
      _legalNameController.text = fields['legalName']?.toString() ?? '';
      _registrationNumberController.text =
          fields['registrationNumber']?.toString() ?? '';
    } catch (_) {
      // New businesses legitimately have no saved details yet. The submit
      // request will surface any meaningful server error to the customer.
    }
  }

  Future<void> _saveCompanyDetails() async {
    await sl<ApiClient>().dio.put<Map<String, dynamic>>(
      '/kyc/company-details',
      data: {
        'legalName': _legalNameController.text.trim(),
        'registrationNumber': _registrationNumberController.text.trim(),
        // These fields have no current UI in the approved KYC flow. Send
        // explicit nulls until their product fields are introduced.
        'taxId': null,
        'billingAddress': null,
      },
    );
  }

  Future<void> _submitKyc() async {
    if (!_formKey.currentState!.validate()) return;
    final requiredDocuments = _docSpecs.where((doc) => !doc.optional);
    final missing = requiredDocuments.where(
      (doc) => !_documents.containsKey(doc.id),
    );
    if (missing.isNotEmpty) {
      showAppSnackBar(context, 'Upload ${missing.first.title} to continue.');
      return;
    }
    setState(() => _submitting = true);
    try {
      if (widget.isBusiness) await _saveCompanyDetails();
      final documentsApi = sl<DocumentApiService>();
      for (final entry in _documents.entries) {
        final document = entry.value;
        final path = document.path;
        if (path == null || path.isEmpty) {
          throw const DocumentPickerException(
            'The selected document is no longer available. Choose it again.',
          );
        }
        final upload = await documentsApi.requestUploadUrl(
          documentType: entry.key,
          fileName: document.name,
          mimeType: document.mimeType,
          fileSizeBytes: document.sizeBytes,
        );
        final uploadUrl = upload['uploadUrl'];
        final fileId = upload['fileId'];
        // Step 3 must use the document type that the server reserved in step
        // 1. This confirms the raw upload and creates the KYC document record.
        final reservedDocumentType = upload['documentType'];
        final documentType =
            reservedDocumentType is String && reservedDocumentType.isNotEmpty
            ? reservedDocumentType
            : entry.key;
        if (uploadUrl is! String || uploadUrl.isEmpty) {
          throw StateError('KYC upload URL response is invalid.');
        }
        if (fileId is! String || fileId.isEmpty) {
          throw StateError('KYC upload response is missing its file ID.');
        }
        await documentsApi.uploadFile(uploadUrl, path, document.mimeType);
        await documentsApi.create(type: documentType, fileId: fileId);
      }
      if (!mounted) return;
      // The latest contract marks KYC ready for review once both company
      // details and all required document bytes are present.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.kycVerificationStatus,
        (route) => false,
      );
    } catch (error) {
      if (mounted) {
        showAppSnackBar(
          context,
          error.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: HomeRouteArgs(verificationUnderReview: widget.isBusiness),
    );
  }

  List<_DocSpec> get _docSpecs => widget.isBusiness
      ? const [
          _DocSpec(
            'tradeLicense',
            'Trade License',
            'Upload a clear copy of your trade license',
          ),
          _DocSpec(
            'vatCertificate',
            'VAT Certificate',
            'Upload your VAT certificate',
            optional: true,
          ),
          _DocSpec(
            'authorizedPersonId',
            'Authorized Person ID',
            'Upload ID of authorized signatory',
          ),
        ]
      : const [
          _DocSpec(
            'emiratesId',
            'Emirates ID',
            'Upload a clear copy of your Emirates ID',
          ),
          _DocSpec(
            'proofOfAddress',
            'Proof of Address',
            'Upload a recent utility bill or bank statement',
            optional: true,
          ),
        ];

  Future<void> _pickDocument(_DocSpec document) async {
    try {
      final selected = await DocumentPickerService.pickDocument(
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (selected == null || !mounted) return;
      setState(() => _documents[document.id] = selected);
    } on DocumentPickerException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final docs = _docSpecs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.scaledV(8)),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                    SvgPicture.asset(
                      AppAssets.antfostLogo,
                      width: context.scaled(140),
                    ),
                  ],
                ),
                SizedBox(height: context.scaledV(16)),
                Text(
                  widget.isBusiness
                      ? 'Verify Your Business'
                      : 'Verify Your Identity',
                  style: AppTextStyles.authScreenTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(26)),
                ),
                SizedBox(height: context.scaledV(4)),
                Text(
                  widget.isBusiness
                      ? 'Secure company verification'
                      : 'Quick identity verification',
                  style: AppTextStyles.cardSubtitle(
                    context,
                  ).copyWith(fontSize: context.scaled(14)),
                ),
                SizedBox(height: context.scaledV(12)),
                AppIllustrationImage(
                  asset: AppAssets.artKycShield,
                  height: 170,
                  borderRadius: 0,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: context.scaledV(12)),
                Row(
                  children: [
                    Text(
                      '1 of 3',
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: context.scaled(14)),
                    Expanded(
                      child: Row(
                        children: List.generate(3, (index) {
                          final isActive = index == 0;
                          return Expanded(
                            child: Container(
                              height: 3.5,
                              margin: EdgeInsets.only(
                                right: index < 2 ? 6.0 : 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : const Color(0xFFE2E6FA),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.scaledV(22)),
                Text(
                  'Upload Documents',
                  style: AppTextStyles.authScreenTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(20)),
                ),
                SizedBox(height: context.scaledV(12)),
                ...docs.map(
                  (d) => Padding(
                    padding: EdgeInsets.only(bottom: context.scaledV(12)),
                    child: _DocumentRow(
                      doc: d,
                      selectedDocument: _documents[d.id],
                      onTap: () => _pickDocument(d),
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(6)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.lg(context)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isBusiness
                            ? 'Company Details'
                            : 'Personal Details',
                        style: AppTextStyles.cardTitle(
                          context,
                        ).copyWith(fontSize: context.scaled(18)),
                      ),
                      SizedBox(height: context.scaledV(12)),
                      Row(
                        children: [
                          Expanded(
                            child: _UnderlineField(
                              label: widget.isBusiness
                                  ? 'Company Legal Name'
                                  : 'Full Legal Name',
                              iconWidget: widget.isBusiness
                                  ? const AppSvgBusinessIcon(
                                      color: AppColors.primary,
                                      size: 18,
                                    )
                                  : const AppSvgUserIcon(
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                              hint: widget.isBusiness
                                  ? 'Enter legal company name'
                                  : 'Enter your full name',
                              controller: _legalNameController,
                              validator: (value) => InputValidators.fullName(
                                value,
                                fieldName: widget.isBusiness
                                    ? 'Company legal name'
                                    : 'Full legal name',
                              ),
                            ),
                          ),
                          Container(
                            width: 1.0,
                            height: 38.0,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            color: const Color(0xFFECEBF5),
                          ),
                          Expanded(
                            child: _UnderlineField(
                              label: widget.isBusiness
                                  ? 'License Number'
                                  : 'Emirates ID Number',
                              iconWidget: const AppSvgLicenseCardIcon(
                                color: AppColors.primary,
                                size: 18,
                              ),
                              hint: widget.isBusiness
                                  ? 'Enter license number'
                                  : 'Enter ID number',
                              controller: _registrationNumberController,
                              validator: (value) =>
                                  InputValidators.tradeRegistration(
                                    value,
                                    widget.isBusiness
                                        ? 'License number'
                                        : 'Emirates ID number',
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.scaledV(14)),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Documents are encrypted and used only for account verification.',
                        style: AppTextStyles.cardSubtitle(
                          context,
                        ).copyWith(fontSize: context.scaled(12)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.scaledV(18)),
                PrimaryButton(
                  onPressed: _submitting ? null : _submitKyc,
                  isLoading: _submitting,
                  arrow: true,
                  label: 'Submit for Verification',
                ),
                SizedBox(height: context.scaledV(10)),
                Center(
                  child: GestureDetector(
                    onTap: _goHome,
                    child: Text(
                      'Save and finish later',
                      style: TextStyle(
                        fontSize: context.scaled(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.scaledV(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DocSpec {
  final String id;
  final String title;
  final String description;
  final bool optional;
  const _DocSpec(
    this.id,
    this.title,
    this.description, {
    this.optional = false,
  });
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({
    required this.doc,
    required this.selectedDocument,
    required this.onTap,
  });

  final _DocSpec doc;
  final SelectedDocument? selectedDocument;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md(context)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const AppSvgDocumentIcon(
                color: AppColors.primary,
                size: 20,
              ),
            ),
            SizedBox(width: AppSpacing.md(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title, style: AppTextStyles.cardTitle(context)),
                  Text(
                    selectedDocument?.name ?? doc.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                ],
              ),
            ),
            if (doc.optional) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Optional',
                  style: AppTextStyles.badgeLabel(
                    context,
                  ).copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              selectedDocument == null
                  ? Icons.upload_file_outlined
                  : Icons.check_circle_rounded,
              color: selectedDocument == null
                  ? AppColors.iconMuted
                  : AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    required this.label,
    required this.iconWidget,
    required this.hint,
    required this.controller,
    required this.validator,
  });

  final String label;
  final Widget iconWidget;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(11),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: context.scaledV(4)),
        Row(
          children: [
            iconWidget,
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 6),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.cardBorder),
                  ),
                ),
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: context.scaled(12),
                      color: AppColors.textHint,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
