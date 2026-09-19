import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/widgets/app_country_code_picker.dart';
import '../../core/services/app_demo_service.dart';

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
import 'domain/entities/auth_flow.dart';
import '../home/presentation/bloc/home_bloc.dart';
import '../home/presentation/bloc/home_event.dart';

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
  Map<String, String> _serverErrors = const {};
  String _countryCode = '+971';

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  bool get _isBusiness => _modeIndex == 0;

  void _goHome() {
    AppDemoService.setDemoMode(true);
    context.read<HomeBloc>().add(const FetchHomeDataEvent());
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      SignInEvent(
        usernameOrMobile: _contactController.text.trim(),
        countryCode: _countryCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!context.mounted || !isCurrentRoute(context)) return;

        if (state is AuthSuccess) {
          final destination =
              state.nextStep == AuthNextStep.kyc ||
                  state.user.kycStatus == 'not_submitted'
              ? AppRoutes.kycVerification
              : AppRoutes.home;
          if (destination == AppRoutes.home) {
            context.read<HomeBloc>().add(const FetchHomeDataEvent());
          }
          Navigator.of(context).pushReplacementNamed(
            destination,
            arguments: destination == AppRoutes.kycVerification ? true : null,
          );
        } else if (state is AuthError) {
          setState(() => _serverErrors = state.fields);
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
              contact: state.challenge.contact.isNotEmpty
                  ? state.challenge.contact
                  : _contactController.text.trim(),
              isEmail: false,
              flow: VerifyAccountFlow.signIn,
              verificationId: state.challenge.verificationId,
              expiresAt: state.challenge.expiresAt,
              resendAvailableAt: state.challenge.resendAvailableAt,
              countryCode: _countryCode,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(24),
                          vertical: context.scaledV(8),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  AppAssets.antfostLogo,
                                  width: context.scaled(140),
                                ),
                              ),
                              SizedBox(height: context.scaledV(12)),
                              SizedBox(
                                height: context.scaledV(170),
                                child: SvgEmbeddedRasterImage(
                                  assetPath: AppAssets.figmaPlant,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: context.scaledV(8)),
                              Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.scaled(22),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.01 * 22,
                                ),
                              ),
                              SizedBox(height: context.scaledV(4)),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: context.scaled(290),
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
                                      height: 1.4,
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
                                  _serverErrors = const {};
                                }),
                              ),
                              SizedBox(height: context.scaledV(12)),
                              AppTextField(
                                label: 'MOBILE NUMBER',
                                controller: _contactController,
                                errorText: _serverErrors['identifier'] ??
                                    _serverErrors['usernameOrMobile'] ??
                                    _serverErrors['mobile'],
                                onChanged: (_) {
                                  _clearServerError('identifier');
                                  _clearServerError('usernameOrMobile');
                                  _clearServerError('mobile');
                                },
                                keyboardType: TextInputType.phone,
                                prefixIconWidget: AppCountryCodePicker(
                                  onChanged: (countryCode) {
                                    setState(() {
                                      _countryCode = countryCode.dialCode ?? '+971';
                                    });
                                  },
                                ),
                                trailingIcon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.iconMuted,
                                ),
                                validator: InputValidators.mobile,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              SizedBox(height: context.scaledV(16)),
                              PrimaryButton(
                                onPressed: isLoading ? null : _onSignIn,
                                isLoading: isLoading,
                                arrow: true,
                                label: 'Log In',
                              ),
                              SizedBox(height: context.scaledV(10)),
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
                              SizedBox(height: context.scaledV(10)),
                              PrimaryButton(
                                variant: PrimaryButtonVariant.outline,
                                onPressed: () => Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.accountType),
                                label: 'Create Account',
                              ),
                              SizedBox(height: context.scaledV(10)),
                              Center(
                                child: GestureDetector(
                                  onTap: _goHome,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: context.scaledV(4),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Want to explore first? ',
                                        style: TextStyle(
                                          fontSize: context.scaled(13),
                                          color: AppColors.textSecondary,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Try Our Demo',
                                            style: TextStyle(
                                              fontSize: context.scaled(13),
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _clearServerError(String field) {
    if (!_serverErrors.containsKey(field)) return;
    setState(() => _serverErrors = Map.of(_serverErrors)..remove(field));
  }
}
