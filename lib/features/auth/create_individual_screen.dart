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
import '../../core/utils/input_validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// Ported from the new Figma design's `screens/CreateIndividual.tsx`.
class CreateIndividualScreen extends StatefulWidget {
  const CreateIndividualScreen({super.key});

  @override
  State<CreateIndividualScreen> createState() => _CreateIndividualScreenState();
}

class _CreateIndividualScreenState extends State<CreateIndividualScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agree = true;
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accept the account terms to continue.')),
      );
      return;
    }
    final contact = _mobileController.text.trim();
    Navigator.of(context).pushNamed(
      AppRoutes.verifyAccount,
      arguments: VerifyAccountRouteArgs(
        contact: contact,
        isEmail: false,
        flow: VerifyAccountFlow.signUp,
        isBusiness: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                AppIllustrationImage(
                  asset: AppAssets.artIndividualHouse,
                  height: 170,
                  borderRadius: 0,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: context.scaledV(10)),
                Text(
                  'Create Individual Account',
                  style: AppTextStyles.authScreenTitle(context),
                ),
                SizedBox(height: context.scaledV(4)),
                Text(
                  'Set up your personal access',
                  style: AppTextStyles.cardSubtitle(context),
                ),
                SizedBox(height: context.scaledV(16)),
                AppTextField(
                  label: 'FULL NAME',
                  controller: _fullNameController,
                  leadingWidget: const AppSvgUserIcon(),
                  validator: InputValidators.fullName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: context.scaledV(12)),
                AppTextField(
                  label: 'MOBILE NUMBER',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  leadingWidget: const AppSvgPhoneIcon(),
                  validator: InputValidators.mobile,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: context.scaledV(12)),
                AppTextField(
                  label: 'NICKNAME / USERNAME',
                  controller: _usernameController,
                  leadingWidget: const AppSvgUserIcon(),
                  validator: InputValidators.username,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: context.scaledV(12)),
                AppTextField(
                  label: 'PASSWORD',
                  obscureText: true,
                  controller: _passwordController,
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
                  'Your mobile number will be verified by OTP.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authNote(context),
                ),
                SizedBox(height: context.scaledV(12)),
                GestureDetector(
                  onTap: () => setState(() => _agree = !_agree),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _agree
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _agree
                                ? AppColors.primary
                                : const Color(0xFFD3D1E4),
                            width: 2,
                          ),
                        ),
                        child: _agree
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: AppSpacing.sm(context)),
                      Text(
                        'I accept the account terms',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.scaledV(16)),
                PrimaryButton(
                  onPressed: _createAccount,
                  arrow: true,
                  label: 'Create Account',
                ),
                SizedBox(height: context.scaledV(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
