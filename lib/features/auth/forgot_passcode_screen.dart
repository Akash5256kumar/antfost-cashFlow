import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/app_country_code_picker.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/route_feedback.dart';
import '../../core/utils/input_validators.dart';
import '../../core/widgets/app_tab_toggle.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';
import 'presentation/bloc/auth_state.dart';

class ForgotPasscodeScreen extends StatefulWidget {
  const ForgotPasscodeScreen({super.key});

  @override
  State<ForgotPasscodeScreen> createState() => _ForgotPasscodeScreenState();
}

class _ForgotPasscodeScreenState extends State<ForgotPasscodeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _tabIndex = 0; // 0 = Email, 1 = Phone
  final _controller = TextEditingController();
  Map<String, String> _serverErrors = const {};
  String _countryCode = '+971';

  /// Returns `true` when the Email tab is active.
  bool get _isEmail => _tabIndex == 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Dispatches [ForgotPasscodeEvent] with the current contact value.
  void _onSendOtp() {
    if (!_formKey.currentState!.validate()) return;
    final contact = _controller.text.trim();
    context.read<AuthBloc>().add(
      ForgotPasscodeEvent(
        contact: contact, 
        isEmail: _isEmail,
        countryCode: _isEmail ? null : _countryCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!context.mounted || !isCurrentRoute(context)) {
          return;
        }

        if (state is AuthOtpSent) {
          // OTP was sent — navigate to the verify-account screen in
          // password-recovery mode.
          Navigator.of(context).pushNamed(
            AppRoutes.verifyAccount,
            arguments: VerifyAccountRouteArgs(
              contact: state.challenge.contact,
              isEmail: _isEmail,
              flow: VerifyAccountFlow.passwordRecovery,
              verificationId: state.challenge.verificationId,
              expiresAt: state.challenge.expiresAt,
              resendAvailableAt: state.challenge.resendAvailableAt,
              countryCode: _isEmail ? null : _countryCode,
            ),
          );
        } else if (state is AuthError) {
          setState(() => _serverErrors = state.fields);
          showSingleSnackBar(context, SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: const BackButton(color: AppColors.textPrimary),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: context.scaledV(12)),

                  // ── Heading ──────────────────────────────────────────────────
                  Text(
                    'Forgot passcode?',
                    style: AppTextStyles.authScreenTitle(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.scaledV(4)),

                  // ── Subtitle ─────────────────────────────────────────────────
                  Text(
                    'Choose your recovery method',
                    style: AppTextStyles.authScreenSubtitle(context),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.scaledV(28)),

                  // ── Tab toggle ────────────────────────────────────────────────
                  AppTabToggle(
                    tabs: const ['Email', 'Phone'],
                    selectedIndex: _tabIndex,
                    onChanged: (i) {
                      // Recreate the field/input connection so Android swaps
                      // email keyboard for the phone keypad (and vice versa).
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        _tabIndex = i;
                        _controller.clear();
                        _serverErrors = const {};
                        _formKey.currentState?.reset();
                      });
                    },
                  ),

                  SizedBox(height: context.scaledV(16)),

                  // ── Input field ───────────────────────────────────────────────
                  AppTextField(
                    key: ValueKey(_tabIndex),
                    label: _tabIndex == 0 ? 'Email' : 'Phone Number',
                    hint: _tabIndex == 0 ? 'Sample.email@.com' : '501 234 567',
                    controller: _controller,
                    errorText: _serverErrors['contact'],
                    onChanged: (_) => _clearServerError('contact'),
                    keyboardType: _tabIndex == 0
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    prefixIconWidget: _tabIndex == 1
                        ? AppCountryCodePicker(
                            onChanged: (countryCode) {
                              setState(() {
                                _countryCode = countryCode.dialCode ?? '+971';
                              });
                            },
                          )
                        : null,
                    validator: _isEmail
                        ? InputValidators.email
                        : InputValidators.mobile,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),

                  SizedBox(height: context.scaledV(28)),

                  // ── Send OTP ──────────────────────────────────────────────────
                  PrimaryButton(
                    label: 'Send OTP',
                    onPressed: isLoading ? null : _onSendOtp,
                    isLoading: isLoading,
                  ),

                  SizedBox(height: context.scaledV(16)),

                  // ── Expiry note ───────────────────────────────────────────────
                  Text(
                    'OTP expires in 5 minutes.',
                    style: AppTextStyles.authNote(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
