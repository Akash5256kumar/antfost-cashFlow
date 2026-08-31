import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/route_feedback.dart';
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
  int _tabIndex = 0; // 0 = Email, 1 = Phone
  final _controller = TextEditingController();

  /// Returns `true` when the Email tab is active.
  bool get _isEmail => _tabIndex == 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Dispatches [ForgotPasscodeEvent] with the current contact value.
  void _onSendOtp() {
    context.read<AuthBloc>().add(
      ForgotPasscodeEvent(contact: _controller.text.trim(), isEmail: _isEmail),
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
              contact: _controller.text.trim().isEmpty
                  ? 'Sample.email@.com'
                  : _controller.text.trim(),
              isEmail: _isEmail,
              flow: VerifyAccountFlow.passwordRecovery,
            ),
          );
        } else if (state is AuthError) {
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
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl(context)),
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
                  onChanged: (i) => setState(() {
                    _tabIndex = i;
                    _controller.clear();
                  }),
                ),

                SizedBox(height: context.scaledV(16)),

                // ── Input field ───────────────────────────────────────────────
                AppTextField(
                  label: _tabIndex == 0 ? 'Email' : 'Phone Number',
                  hint: _tabIndex == 0 ? 'Sample.email@.com' : '501 234 567',
                  controller: _controller,
                  keyboardType: _tabIndex == 0
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
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
        );
      },
    );
  }
}
