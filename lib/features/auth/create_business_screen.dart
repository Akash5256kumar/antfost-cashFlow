import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_svg_icons.dart';
import '../../core/utils/input_validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';
import '../../core/utils/route_feedback.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';
import 'presentation/bloc/auth_state.dart';

/// Ported from the new Figma design's `screens/CreateBusiness.tsx`.
class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Map<String, String> _serverErrors = const {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _usernameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _serverErrors = const {};
      _isSubmitting = true;
    });
    context.read<AuthBloc>().add(
      SignUpBusinessEvent(
        companyName: _companyNameController.text.trim(),
        username: _usernameController.text.trim(),
        registeredMobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!context.mounted || !isCurrentRoute(context)) return;
        if (state is AuthOtpSent) {
          setState(() => _isSubmitting = false);
          Navigator.of(context).pushNamed(
            AppRoutes.verifyAccount,
            arguments: VerifyAccountRouteArgs(
              contact: state.challenge.contact,
              isEmail: false,
              flow: VerifyAccountFlow.signUp,
              isBusiness: true,
              verificationId: state.challenge.verificationId,
              expiresAt: state.challenge.expiresAt,
              resendAvailableAt: state.challenge.resendAvailableAt,
            ),
          );
        } else if (state is AuthError) {
          setState(() {
            _isSubmitting = false;
            _serverErrors = state.fields;
          });
          showAppSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg(context)),
            child: Form(
              key: _formKey,
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
                  SizedBox(height: context.scaledV(12)),
                  SizedBox(
                    height: context.scaledV(170),
                    child: SvgEmbeddedRasterImage(
                      assetPath: AppAssets.figmaPlant,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: context.scaledV(10)),
                  Text(
                    'Create Business Account',
                    style: AppTextStyles.authScreenTitle(context),
                  ),
                  SizedBox(height: context.scaledV(4)),
                  Text(
                    'Set up your company access',
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                  SizedBox(height: context.scaledV(16)),
                  AppTextField(
                    label: 'COMPANY NAME',
                    controller: _companyNameController,
                    errorText: _serverErrors['companyName'],
                    onChanged: (_) => _clearServerError('companyName'),
                    leadingWidget: const AppSvgBusinessIcon(),
                    validator: (value) => InputValidators.fullName(
                      value,
                      fieldName: 'Company name',
                    ),
                    // Confirm-password validation runs on submit so users can
                    // enter the full value without an error on every key.
                  ),
                  SizedBox(height: context.scaledV(12)),
                  AppTextField(
                    label: 'EMAIL ADDRESS',
                    controller: _emailController,
                    errorText: _serverErrors['email_id'],
                    onChanged: (_) => _clearServerError('email_id'),
                    keyboardType: TextInputType.emailAddress,
                    leadingWidget: const Icon(Icons.email_outlined),
                    validator: (value) => InputValidators.email(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: context.scaledV(12)),
                  AppTextField(
                    label: 'BUSINESS USERNAME',
                    controller: _usernameController,
                    errorText: _serverErrors['username'],
                    onChanged: (_) => _clearServerError('username'),
                    leadingWidget: const AppSvgUserIcon(),
                    validator: (value) => InputValidators.username(
                      value,
                      fieldName: 'Business username',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: context.scaledV(12)),
                  AppTextField(
                    label: 'REGISTERED MOBILE',
                    controller: _mobileController,
                    errorText: _serverErrors['registeredMobile'],
                    onChanged: (_) => _clearServerError('registeredMobile'),
                    keyboardType: TextInputType.phone,
                    leadingWidget: const AppSvgPhoneIcon(),
                    validator: InputValidators.mobile,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: context.scaledV(12)),
                  AppTextField(
                    label: 'PASSWORD',
                    obscureText: true,
                    controller: _passwordController,
                    errorText: _serverErrors['password'],
                    onChanged: (_) => _clearServerError('password'),
                    leadingWidget: const AppSvgLockIcon(),
                    validator: InputValidators.password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: context.scaledV(12)),
                  AppTextField(
                    label: 'CONFIRM PASSWORD',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    leadingWidget: const AppSvgLockIcon(),
                    validator: (value) => InputValidators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: context.scaledV(16)),
                  Text(
                    'You can plan an order while verification is in progress.\n'
                    'Payment activates after approval.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authNote(context),
                  ),
                  SizedBox(height: context.scaledV(16)),
                  PrimaryButton(
                    onPressed: _isSubmitting ? null : _createAccount,
                    isLoading: _isSubmitting,
                    arrow: true,
                    label: 'Create Account',
                  ),
                  SizedBox(height: context.scaledV(16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearServerError(String field) {
    if (!_serverErrors.containsKey(field)) return;
    setState(() => _serverErrors = Map.of(_serverErrors)..remove(field));
  }
}
