import 'package:flutter/material.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_tab_toggle.dart';
import '../../core/widgets/app_text_field.dart';

class ForgotPasscodeScreen extends StatefulWidget {
  const ForgotPasscodeScreen({super.key});

  @override
  State<ForgotPasscodeScreen> createState() => _ForgotPasscodeScreenState();
}

class _ForgotPasscodeScreenState extends State<ForgotPasscodeScreen> {
  int _tabIndex = 0; // 0 = Email, 1 = Phone
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Forgot passcode?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.authBodyTop),

            // ── Subtitle ─────────────────────────────────────────────────
            const Text(
              'Choose your recovery method',
              style: AppTextStyles.authScreenSubtitle,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Tab toggle ────────────────────────────────────────────────
            AppTabToggle(
              tabs: const ['Email', 'Phone'],
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Input field ───────────────────────────────────────────────
            AppTextField(
              label: _tabIndex == 0 ? 'Email' : 'Phone Number',
              hint: _tabIndex == 0 ? 'Sample.email@.com' : '501 234 567',
              controller: _controller,
              keyboardType: _tabIndex == 0
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Send OTP ──────────────────────────────────────────────────
            AppGradientButton(
              label: 'Send OTP',
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.verifyAccount,
                arguments: VerifyAccountRouteArgs(
                  contact: _controller.text.trim().isEmpty
                      ? 'Sample.email@.com'
                      : _controller.text.trim(),
                  isEmail: _tabIndex == 0,
                  flow: VerifyAccountFlow.passwordRecovery,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Expiry note ───────────────────────────────────────────────
            const Text(
              'OTP expires in 5 minutes.',
              style: AppTextStyles.authNote,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
