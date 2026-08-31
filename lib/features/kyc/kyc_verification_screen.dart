import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// Ported from the new Figma design's `screens/VerifyBusiness.tsx`. The
/// Figma flow shows this same screen after OTP regardless of account type
/// and hands off straight to Home (no separate pending/status screen) —
/// [isBusiness] only swaps the copy/field labels between the business and
/// individual document sets, since the old app's richer status screens
/// (`KycPendingScreen`, `VerificationStatusScreen`) aren't part of that flow
/// anymore but stay in the codebase, restyled, in case something still
/// links to them directly.
class KycVerificationScreen extends StatefulWidget {
  final bool isBusiness;

  const KycVerificationScreen({super.key, this.isBusiness = true});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  void _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: HomeRouteArgs(verificationUnderReview: widget.isBusiness),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docs = widget.isBusiness
        ? const [
            _DocSpec(
              'Trade License',
              'Upload a clear copy of your trade license',
            ),
            _DocSpec(
              'VAT Certificate',
              'Upload your VAT certificate',
              optional: true,
            ),
            _DocSpec(
              'Authorized Person ID',
              'Upload ID of authorized signatory',
            ),
          ]
        : const [
            _DocSpec('Emirates ID', 'Upload a clear copy of your Emirates ID'),
            _DocSpec(
              'Proof of Address',
              'Upload a recent utility bill or bank statement',
              optional: true,
            ),
          ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  child: _DocumentRow(doc: d),
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
              PrimaryButton(onPressed: _goHome, arrow: true, label: 'Continue'),
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
    );
  }
}

class _DocSpec {
  final String title;
  final String description;
  final bool optional;
  const _DocSpec(this.title, this.description, {this.optional = false});
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.doc});

  final _DocSpec doc;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  doc.description,
                  style: AppTextStyles.cardSubtitle(context),
                ),
              ],
            ),
          ),
          if (doc.optional) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const Icon(Icons.chevron_right_rounded, color: AppColors.iconMuted),
        ],
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    required this.label,
    required this.iconWidget,
    required this.hint,
  });

  final String label;
  final Widget iconWidget;
  final String hint;

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
                child: Text(
                  hint,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: AppColors.textHint,
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
