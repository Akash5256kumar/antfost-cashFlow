import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/utils/route_feedback.dart';
import '../../core/utils/input_validators.dart';
import '../../core/widgets/app_tab_toggle.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';
import 'presentation/bloc/auth_state.dart';

/// Ported from the new Figma design's `screens/Login.tsx` — a Business /
/// Individual segmented toggle drives the copy and the credential field's
/// label/icon, rather than the old Email / Phone tabs.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  int _modeIndex = 0; // 0 = Business, 1 = Individual

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  bool get _isBusiness => _modeIndex == 0;

  void _goHome() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      SignInEvent(
        contact: _contactController.text.trim(),
        passcode: _passcodeController.text.trim(),
        isEmail: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!context.mounted || !isCurrentRoute(context)) return;

        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state is AuthError) {
          showSingleSnackBar(
            context,
            SnackBar(
              content: Text(state.message),
              action: SnackBarAction(label: 'Retry', onPressed: _onSignIn),
            ),
          );
        } else if (state is AuthOtpSent) {
          Navigator.of(context).pushNamed(
            AppRoutes.verifyAccount,
            arguments: VerifyAccountRouteArgs(
              contact: _contactController.text.trim(),
              isEmail: false,
              flow: VerifyAccountFlow.signUp,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              // Figma: `px-6 pb-6 pt-2` (24px sides, 24px bottom) + the
              // logo's own `mt-1` (4px) folded into the top inset.
              padding: EdgeInsets.fromLTRB(
                context.scaled(24),
                context.scaledV(12),
                context.scaled(24),
                context.scaledV(24),
              ),
              child: Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hPad = context.scaled(24);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.antfostLogo,
                            height: context.scaled(76),
                          ),
                        ),
                        // Full-bleed, natural aspect ratio, faded at the
                        // bottom — matches Figma's `-mx-7` + mask-image.
                        SizedBox(
                          height: context.scaledV(190),
                          child: OverflowBox(
                            maxWidth: constraints.maxWidth + hPad * 2.6,
                            minWidth: constraints.maxWidth + hPad * 2.6,
                            child: SvgEmbeddedRasterImage(
                              assetPath: AppAssets.figmaPlant,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        SizedBox(height: context.scaledV(8)),
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.scaled(20),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.01 * 20,
                          ),
                        ),
                        SizedBox(height: context.scaledV(0)),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.scaled(270),
                          ),
                          child: Center(
                            child: Text(
                              _isBusiness
                                  ? 'Plan concrete orders, manage project sites and track live deliveries.'
                                  : 'Log in to manage your projects, orders and deliveries.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.625,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.scaledV(12)),
                        AppTabToggle(
                          tabs: const ['Business', 'Individual'],
                          selectedIndex: _modeIndex,
                          onChanged: (i) => setState(() {
                            _modeIndex = i;
                            _contactController.clear();
                          }),
                        ),
                        SizedBox(height: context.scaledV(16)),
                        AppTextField(
                          label: _isBusiness
                              ? 'BUSINESS USERNAME'
                              : 'MOBILE NUMBER OR USERNAME',
                          controller: _contactController,
                          leadingIcon: _isBusiness
                              ? Icons.lock_outline
                              : Icons.person_outline,
                          trailingIcon: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.iconMuted,
                          ),
                          validator: (value) => InputValidators.loginIdentifier(
                            value,
                            isBusiness: _isBusiness,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: context.scaledV(12)),
                        AppTextField(
                          label: 'PASSWORD',
                          obscureText: true,
                          controller: _passcodeController,
                          leadingIcon: Icons.lock_outline,
                          validator: InputValidators.password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: context.scaledV(8)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.forgotPasscode),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: context.scaled(12),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.scaledV(16)),
                        PrimaryButton(
                          onPressed: isLoading ? null : _onSignIn,
                          isLoading: isLoading,
                          arrow: true,
                          label: 'Log In',
                        ),
                        SizedBox(height: context.scaledV(12)),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md(context),
                              ),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: context.scaled(12),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.divider),
                            ),
                          ],
                        ),
                        SizedBox(height: context.scaledV(12)),
                        PrimaryButton(
                          variant: PrimaryButtonVariant.outline,
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.accountType),
                          label: 'Create Account',
                        ),
                        SizedBox(height: context.scaledV(12)),
                        PrimaryButton(
                          variant: PrimaryButtonVariant.outline,
                          onPressed: _goHome,
                          label: 'Try Our Demo',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
