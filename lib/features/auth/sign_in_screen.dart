import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/widgets/app_tab_toggle.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/guest_mode_sheet.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  int _tabIndex = 0; // 0 = Email, 1 = Phone
  bool _remember = false;

  void _goHome() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.authLogoTop),

              // ── Logo ──────────────────────────────────────────────────────
              SvgPicture.asset(AppAssets.antfostLogo, height: 80),

              const SizedBox(height: AppSpacing.xxl),

              // ── Heading ───────────────────────────────────────────────────
              const Text(
                'Welcome back',
                style: AppTextStyles.authScreenTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Sign in to access your orders and projects',
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

              // ── Credential field ──────────────────────────────────────────
              if (_tabIndex == 0)
                AppTextField(
                  label: 'Email',
                  hint: 'Sample.email@.com',
                  keyboardType: TextInputType.emailAddress,
                )
              else
                _PhoneField(),

              const SizedBox(height: AppSpacing.md),

              // ── Passcode ──────────────────────────────────────────────────
              const AppTextField(label: 'Passcode', obscureText: true),

              const SizedBox(height: AppSpacing.md),

              // ── Remember + Forgot ─────────────────────────────────────────
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v ?? false),
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
                  const Text(
                    'Remember',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.forgotPasscode),
                    child: const Text(
                      'Forgot passcode?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Sign In button ────────────────────────────────────────────
              AppGradientButton(label: 'Sign In', onPressed: _goHome),

              const SizedBox(height: AppSpacing.xl),

              // ── Or divider ────────────────────────────────────────────────
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'Or',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Continue as Guest ─────────────────────────────────────────
              AppOutlineButton(
                label: 'Continue as Guest',
                onPressed: () => showGuestModeSheet(
                  context,
                  onContinue: _goHome,
                  onSignIn: () {},
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Sign Up link ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.createAccount,
                      arguments: const CreateAccountRouteArgs(
                        entryPoint: CreateAccountEntryPoint.signIn,
                      ),
                    ),
                    child: const Text('Sign Up', style: AppTextStyles.authLink),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Phone field with UAE prefix ───────────────────────────────────────────────
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
