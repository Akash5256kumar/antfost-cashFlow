import 'package:flutter/material.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    super.key,
    this.entryPoint = CreateAccountEntryPoint.getStarted,
  });

  final CreateAccountEntryPoint entryPoint;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _agreed = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _openVerifyAccount() {
    final contact = _emailController.text.trim().isEmpty
        ? 'Sample.email@.com'
        : _emailController.text.trim();

    Navigator.of(context).pushNamed(
      AppRoutes.verifyAccount,
      arguments: VerifyAccountRouteArgs(
        contact: contact,
        isEmail: true,
        flow: VerifyAccountFlow.signUp,
      ),
    );
  }

  void _returnToSignIn() {
    if (widget.entryPoint == CreateAccountEntryPoint.signIn &&
        Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
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
          'Create account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.authBodyTop),

            // ── Subtitle ─────────────────────────────────────────────────
            const Text(
              'Sign up to start ordering concrete',
              style: AppTextStyles.authScreenSubtitle,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Full Name ─────────────────────────────────────────────────
            const AppTextField(label: 'Full Name', hint: 'Omar'),

            const SizedBox(height: AppSpacing.md),

            // ── Email ─────────────────────────────────────────────────────
            AppTextField(
              label: 'Email Address',
              hint: 'Sample.email@.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Phone number ──────────────────────────────────────────────
            _PhoneField(),

            const SizedBox(height: AppSpacing.md),

            // ── Company ───────────────────────────────────────────────────
            const AppTextField(
              label: 'Company name (As per license)',
              hint: 'Omar Construction',
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Passcode ──────────────────────────────────────────────────
            const AppTextField(label: 'Passcode', obscureText: true),

            const SizedBox(height: AppSpacing.md),

            // ── Confirm Passcode ──────────────────────────────────────────
            const AppTextField(label: 'Confirm Passcode', obscureText: true),

            const SizedBox(height: AppSpacing.lg),

            // ── Terms checkbox ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    activeColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.checkboxBorder,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.link,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.link,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Sign Up button ────────────────────────────────────────────
            AppGradientButton(label: 'Sign Up', onPressed: _openVerifyAccount),

            const SizedBox(height: AppSpacing.xl),

            // ── Sign in link ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: _returnToSignIn,
                  child: const Text('Sign in', style: AppTextStyles.authLink),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ── Reusable phone field with UAE prefix ──────────────────────────────────────
class _PhoneField extends StatefulWidget {
  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  final _focus = FocusNode();
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _active = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _active ? AppColors.fieldActiveBg : AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: _active ? AppColors.primary : AppColors.fieldBorder,
          width: _active ? 1.5 : 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 12,
              color: _active ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              const Text('🇦🇪', style: TextStyle(fontSize: 18, height: 1.4)),
              const SizedBox(width: 4),
              const Text(
                '+971',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                color: AppColors.fieldBorder,
              ),
              Expanded(
                child: TextField(
                  focusNode: _focus,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: '501 234 567',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
