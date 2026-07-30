import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/route_feedback.dart';
import '../../core/widgets/app_gradient_button.dart';
import '../../core/widgets/app_tab_toggle.dart';
import '../../core/widgets/app_text_field.dart';
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
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: const BackButton(color: AppColors.textPrimary),
            title: const Text(
              'Forgot passcode?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.authBodyTop),

                // ── Subtitle ─────────────────────────────────────────────────
                const Text(
                  'Choose your recovery method',
                  style: AppTextStyles.authScreenSubtitle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Tab toggle ────────────────────────────────────────────────
                AppTabToggle(
                  tabs: const ['Email', 'Phone'],
                  selectedIndex: _tabIndex,
                  onChanged: (i) => setState(() {
                    _tabIndex = i;
                    _controller.clear();
                  }),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Input field ───────────────────────────────────────────────
                AppTextField(
                  label: _tabIndex == 0 ? 'Email' : 'Phone Number',
                  hint: _tabIndex == 0 ? 'Sample.email@.com' : '501 234 567',
                  controller: _controller,
                  keyboardType: _tabIndex == 0
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Send OTP ──────────────────────────────────────────────────
                // Show a loading container while the request is in-flight,
                // otherwise the active "Send OTP" button.
                if (isLoading)
                  _LoadingButton()
                else
                  AppGradientButton(label: 'Send OTP', onPressed: _onSendOtp),

                const SizedBox(height: AppSpacing.lg),

                // ── Expiry note ───────────────────────────────────────────────
                const Text(
                  'OTP expires in 5 minutes.',
                  style: AppTextStyles.authNote,
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

// ── Loading button placeholder ────────────────────────────────────────────────
//
// Renders a gradient container matching [AppGradientButton] visually but
// displays a [CircularProgressIndicator] while the OTP request is in-flight.
class _LoadingButton extends StatelessWidget {
  const _LoadingButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.button),
      ),
      child: const SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}
