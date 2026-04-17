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
import '../../core/widgets/guest_mode_sheet.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  void _openGuestSheet(BuildContext context) {
    showGuestModeSheet(
      context,
      onContinue: () => Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
      onSignIn: () => Navigator.of(context).pushNamed(AppRoutes.signIn),
    );
  }

  void _openSignIn(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.signIn);
  }

  void _openCreateAccount(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.createAccount,
      arguments: const CreateAccountRouteArgs(
        entryPoint: CreateAccountEntryPoint.getStarted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // ── Logo ────────────────────────────────────────────────────
              SvgPicture.asset(AppAssets.antfostLogo, height: 90),

              const Spacer(flex: 3),

              // ── Heading ─────────────────────────────────────────────────
              const Text(
                'Get Started',
                style: AppTextStyles.authScreenTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Choose how you want to continue',
                style: AppTextStyles.authScreenSubtitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Language selector ────────────────────────────────────────
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'English',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 4),

              // ── Continue as Guest ────────────────────────────────────────
              AppOutlineButton(
                label: 'Continue as Guest',
                onPressed: () => _openGuestSheet(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '*Guest mode is a demo experience. Order history and some support features are limited.',
                style: AppTextStyles.authNote,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Sign In ──────────────────────────────────────────────────
              AppGradientButton(
                label: 'Sign In',
                onPressed: () => _openSignIn(context),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Create Account ───────────────────────────────────────────
              GestureDetector(
                onTap: () => _openCreateAccount(context),
                child: const Text(
                  'Create Account',
                  style: AppTextStyles.authLink,
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
