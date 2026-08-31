import 'package:flutter/material.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_tab_toggle.dart';
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
  int _accountType = 0; // 0 = Business, 1 = Individual Professional
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
        isBusiness: _accountType == 0,
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
      ),
      body: SafeArea(
        // A scroll view that only engages if the content doesn't fit —
        // this renders identically to a plain Column when there's room,
        // and becomes scrollable instead of overflowing on smaller
        // screens or with larger system font sizes.
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.scaledV(4)),

              // ── Heading ──────────────────────────────────────────────────
              Text(
                'Create account',
                style: AppTextStyles.authScreenTitle(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.scaledV(4)),

              // ── Subtitle ─────────────────────────────────────────────────
              Text(
                'Sign up to start ordering concrete',
                style: AppTextStyles.authScreenSubtitle(context),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.scaledV(16)),

              // ── Account type tab toggle ──────────────────────────────────
              AppTabToggle(
                tabs: const ['Business', 'Individual Professional'],
                selectedIndex: _accountType,
                onChanged: (i) => setState(() => _accountType = i),
              ),

              SizedBox(height: context.scaledV(16)),

              // ── Full Name ─────────────────────────────────────────────────
              const AppTextField(label: 'Full Name', hint: 'Omar'),

              SizedBox(height: context.scaledV(8)),

              // ── Email ─────────────────────────────────────────────────────
              AppTextField(
                label: 'Email Address',
                hint: 'Sample.email@.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: context.scaledV(8)),

              // ── Trade License (Business) / Phone number (Individual) ───────
              if (_accountType == 0)
                const _DocumentUploadField(
                  label: 'Trade License',
                  isRequired: true,
                )
              else
                _PhoneField(),

              SizedBox(height: context.scaledV(8)),

              // ── Company ───────────────────────────────────────────────────
              const AppTextField(
                label: 'Company name (As per license)',
                hint: 'Omar Construction',
              ),

              // ── VAT Registration Certificate (Business only) ───────────────
              if (_accountType == 0) ...[
                SizedBox(height: context.scaledV(8)),
                const _DocumentUploadField(
                  label: 'VAT Registration Certificate (If applicable)',
                ),
              ],

              SizedBox(height: context.scaledV(8)),

              // ── Passcode ──────────────────────────────────────────────────
              const AppTextField(label: 'Passcode', obscureText: true),

              SizedBox(height: context.scaledV(8)),

              // ── Confirm Passcode ──────────────────────────────────────────
              const AppTextField(label: 'Confirm Passcode', obscureText: true),

              SizedBox(height: context.scaledV(12)),

              // ── Terms checkbox ────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.scaled(22),
                    height: context.scaled(22),
                    child: Checkbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      activeColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.checkboxBorder,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.scaled(4)),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm(context)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Terms of Service',
                                style: TextStyle(
                                  fontSize: context.scaled(13),
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
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: context.scaled(13),
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

              SizedBox(height: context.scaledV(16)),

              // ── Sign Up button ────────────────────────────────────────────
              AppGradientButton(
                label: 'Sign Up',
                onPressed: _openVerifyAccount,
              ),

              SizedBox(height: context.scaledV(12)),

              // ── Sign in link ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: context.scaled(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _returnToSignIn,
                    child: Text(
                      'Sign in',
                      style: AppTextStyles.authLink(context),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.scaledV(16)),
            ],
          ),
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
        borderRadius: BorderRadius.circular(AppSpacing.md(context)),
        border: Border.all(
          color: _active ? AppColors.primary : AppColors.fieldBorder,
          width: _active ? 1.5 : 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg(context),
        vertical: AppSpacing.xs(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phone Number',
            style: TextStyle(
              fontSize: context.scaled(12),
              color: _active ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Text(
                '🇦🇪',
                style: TextStyle(fontSize: context.scaled(18), height: 1.4),
              ),
              SizedBox(width: context.scaled(4)),
              Text(
                '+971',
                style: TextStyle(
                  fontSize: context.scaled(15),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: context.scaled(16),
                color: AppColors.textSecondary,
              ),
              Container(
                width: 1,
                height: context.scaled(20),
                margin: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm(context),
                ),
                color: AppColors.fieldBorder,
              ),
              Expanded(
                child: TextField(
                  focusNode: _focus,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: context.scaled(15),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '501 234 567',
                    hintStyle: TextStyle(
                      fontSize: context.scaled(15),
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: context.scaled(10),
                    ),
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

// ── Document upload field (Trade License / VAT certificate) ───────────────────
class _DocumentUploadField extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _DocumentUploadField({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg(context),
          vertical: AppSpacing.sm(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(AppSpacing.md(context)),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: context.scaled(12),
                  color: AppColors.textSecondary,
                ),
                children: isRequired
                    ? const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ]
                    : null,
              ),
            ),
            SizedBox(height: context.scaledV(4)),
            Text(
              'Upload document',
              style: TextStyle(
                fontSize: context.scaled(15),
                color: AppColors.textHint,
              ),
            ),
            SizedBox(height: context.scaledV(4)),
            Icon(
              Icons.file_upload_outlined,
              size: context.scaled(18),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
