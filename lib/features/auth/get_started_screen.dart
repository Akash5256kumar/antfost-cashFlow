import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/widgets/guest_mode_sheet.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  void _openGuestSheet(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
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
        // This screen distributes its content with Spacers to fill the
        // screen exactly as before. LayoutBuilder + a min-height
        // ConstrainedBox + IntrinsicHeight preserves that distribution
        // when everything fits, but lets the whole thing scroll instead
        // of overflowing on smaller screens or larger system font sizes
        // (Spacer needs a bounded height, which IntrinsicHeight provides
        // even inside a scroll view).
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),

                        // ── Logo ────────────────────────────────────────────────────
                        SvgPicture.asset(
                          AppAssets.antfostLogo,
                          height: context.scaled(90),
                        ),

                        const Spacer(flex: 1),

                        // ── Heading ─────────────────────────────────────────────────
                        Text(
                          'Get Started',
                          style: AppTextStyles.authScreenTitle(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.scaledV(4)),
                        Text(
                          'Choose how you want to continue',
                          style: AppTextStyles.authScreenSubtitle(context),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: context.scaledV(16)),

                        // ── Language selector ────────────────────────────────────────
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: context.scaled(18),
                                color: AppColors.primary,
                              ),
                              SizedBox(width: context.scaled(6)),
                              Text(
                                'English',
                                style: TextStyle(
                                  fontSize: context.scaled(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: context.scaled(4)),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: context.scaled(18),
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 7),

                        // ── Continue as Guest ────────────────────────────────────────
                        AppOutlineButton(
                          label: 'Continue as Guest',
                          onPressed: () => _openGuestSheet(context),
                        ),
                        SizedBox(height: context.scaledV(12)),
                        Text(
                          '*Guest mode is a demo experience. Order history and some support features are limited.',
                          style: TextStyle(
                            fontSize: context.scaled(12),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: context.scaledV(22)),

                        // ── Sign In ──────────────────────────────────────────────────
                        AppGradientButton(
                          label: 'Sign In',
                          onPressed: () => _openSignIn(context),
                        ),

                        SizedBox(height: context.scaledV(22)),

                        // ── Create Account ───────────────────────────────────────────
                        GestureDetector(
                          onTap: () => _openCreateAccount(context),
                          child: Text(
                            'Create Account',
                            style: AppTextStyles.authLink(context),
                          ),
                        ),

                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
