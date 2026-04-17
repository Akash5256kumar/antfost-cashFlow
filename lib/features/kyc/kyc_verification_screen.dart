import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_gradient_button.dart';

// ── Colours local to this screen ─────────────────────────────────────────────
const Color _bannerBg = Color(0xFFFFF5F5);
const Color _bannerBorder = Color(0xFFFFCDD2);
const Color _bannerRed = Color(0xFFD32F2F);
const Color _requiredRed = Color(0xFFE53935);
const Color _cardBg = Color(0xFFFFFFFF);

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  bool _hasCompany = true;
  bool _vatRegistered = true;
  final _vatController = TextEditingController();

  @override
  void dispose() {
    _vatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leading: const BackButton(color: AppColors.textPrimary),
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'KYC Verification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Upload required documents for verification',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status banner ────────────────────────────────────────
                  const _StatusBanner(),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Company toggle ───────────────────────────────────────
                  _QuestionCard(
                    question: 'Do you have a company?',
                    subtext: 'Trade license required if\negistered',
                    value: _hasCompany,
                    onChanged: (v) => setState(() => _hasCompany = v),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── VAT registered toggle ────────────────────────────────
                  _QuestionCard(
                    question: 'VAT Registered?',
                    subtext: 'VAT certificate required if\nregistered',
                    value: _vatRegistered,
                    onChanged: (v) => setState(() => _vatRegistered = v),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── VAT number field ─────────────────────────────────────
                  _VatNumberField(controller: _vatController),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Document upload cards ────────────────────────────────
                  _DocumentCard(
                    title: 'Emirates ID (Front)',
                    description: 'Upload front side of\nEmirates ID',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _DocumentCard(
                    title: 'Emirates ID (Back)',
                    description: 'Upload back side of\nEmirates ID',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _DocumentCard(
                    title: 'Trade License',
                    description: 'Upload company trade\nlicense',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _DocumentCard(
                    title: 'VAT Certificate',
                    description: 'Upload VAT registration\ncertificate',
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Important notes ──────────────────────────────────────
                  const _ImportantNotes(),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),

          // ── Fixed submit button ────────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              bottomInset > 0 ? bottomInset + AppSpacing.xs : AppSpacing.lg,
            ),
            child: AppGradientButton(
              label: 'Submit for verification',
              onPressed: () => Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.kycPending),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status banner ─────────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  const _StatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: _bannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning_amber_rounded, color: _bannerRed, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _bannerRed,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upload all required documents. Verification usually takes 2-4 hours during business hours.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.45,
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

// ── Yes / No question card ────────────────────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final String question;
  final String subtext;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _QuestionCard({
    required this.question,
    required this.subtext,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtext,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _YesNoToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ── Yes / No pill toggle ──────────────────────────────────────────────────────
class _YesNoToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _YesNoToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TogglePill(
            label: 'Yes',
            active: value,
            onTap: () => onChanged(true),
          ),
          _TogglePill(
            label: 'No',
            active: !value,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TogglePill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── VAT number field ──────────────────────────────────────────────────────────
class _VatNumberField extends StatelessWidget {
  final TextEditingController controller;

  const _VatNumberField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VAT Number*',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: '123456789000003',
                  hintStyle: TextStyle(fontSize: 15, color: AppColors.textHint),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: AppSpacing.xs),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            '15-digit TRN number (e.g., 123456789000003)',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

// ── Document upload card ──────────────────────────────────────────────────────
class _DocumentCard extends StatelessWidget {
  final String title;
  final String description;

  const _DocumentCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: _requiredRed),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.upload_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 3),
                  Text(
                    'Not Uploaded',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Upload button ────────────────────────────────────────────────
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.textPrimary, width: 1.2),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.upload_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  'Choose file or take photo',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Supported formats ────────────────────────────────────────────
          const Center(
            child: Text(
              'Supported: JPG, PNG, PDF (Max 10MB)',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Important notes ───────────────────────────────────────────────────────────
class _ImportantNotes extends StatelessWidget {
  static const _items = [
    'Documents must be clear and all details visible',
    'Emirates ID must be valid (not expired)',
    'Trade license must match company name',
    'VAT number must be 15 digits',
    'Verification takes 2-4 business hours',
  ];

  const _ImportantNotes();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Important Notes',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._items.map(
          (note) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    note,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
