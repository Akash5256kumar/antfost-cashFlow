import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/route_feedback.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/app_svg_icons.dart';
import '../../core/widgets/primary_button.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';
import 'presentation/bloc/auth_state.dart';
import 'domain/entities/auth_flow.dart';

/// Six-digit OTP verification with the device's native numeric keyboard.
class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({
    super.key,
    required this.contact,
    this.isEmail = true,
    this.flow = VerifyAccountFlow.signUp,
    this.isBusiness = true,
    this.verificationId = '',
  });

  final String contact;
  final bool isEmail;
  final VerifyAccountFlow flow;
  final bool isBusiness;
  final String verificationId;

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 45;

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  late String _verificationId;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  String get _code => _otpController.text;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _otpController.addListener(_onOtpChanged);
    _otpFocusNode.addListener(_onOtpChanged);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController
      ..removeListener(_onOtpChanged)
      ..dispose();
    _otpFocusNode.removeListener(_onOtpChanged);
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _onOtpChanged() => setState(() {});

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _handleContinue() {
    if (_code.length != _otpLength) {
      _otpFocusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit verification code.')),
      );
      return;
    }
    context.read<AuthBloc>().add(
      widget.flow == VerifyAccountFlow.signUp
          ? VerifySignUpOtpEvent(verificationId: _verificationId, otp: _code)
          : VerifyPasscodeOtpEvent(
              verificationId: _verificationId,
              contact: widget.contact,
              otp: _code,
            ),
    );
  }

  void _handleResend() {
    context.read<AuthBloc>().add(
      widget.flow == VerifyAccountFlow.signUp
          ? ResendSignUpOtpEvent(_verificationId)
          : ForgotPasscodeEvent(
              contact: widget.contact,
              isEmail: widget.isEmail,
            ),
    );
    _startTimer();
    setState(() {});
  }

  String get _timerLabel {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!context.mounted || !isCurrentRoute(context)) return;

        if (state is AuthOtpVerified) {
          switch (widget.flow) {
            case VerifyAccountFlow.signUp:
              if (state.session.nextStep == AuthNextStep.kyc) {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.kycVerification,
                  arguments: true,
                );
              } else {
                // KYC screen commented out for Individual flow as requested — goes directly to Home
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                  arguments: const HomeRouteArgs(
                    verificationUnderReview: false,
                  ),
                );
              }
            case VerifyAccountFlow.passwordRecovery:
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
          }
        } else if (state is AuthResetTokenReady) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.resetPasscode,
            arguments: ResetPasscodeRouteArgs(resetToken: state.resetToken),
          );
        } else if (state is AuthOtpSent) {
          _verificationId = state.challenge.verificationId;
          showSingleSnackBar(
            context,
            const SnackBar(content: Text('OTP resent successfully.')),
          );
        } else if (state is AuthError) {
          showSingleSnackBar(context, SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg(context),
                context.scaledV(8),
                AppSpacing.lg(context),
                context.scaledV(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: AppColors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      shadowColor: AppColors.textPrimary.withValues(
                        alpha: 0.06,
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: SizedBox(
                          width: context.scaled(44),
                          height: context.scaled(44),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: context.scaled(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(44)),
                  Text(
                    'OTP Verification',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authScreenTitle(context),
                  ),
                  SizedBox(height: context.scaledV(14)),
                  Text(
                    'Enter the 6-digit code sent to',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authScreenSubtitle(context),
                  ),
                  SizedBox(height: context.scaledV(20)),
                  _ContactCard(
                    contact: widget.contact,
                    isEmail: widget.isEmail,
                  ),
                  SizedBox(height: context.scaledV(40)),
                  _OtpFields(
                    controller: _otpController,
                    focusNode: _otpFocusNode,
                  ),
                  SizedBox(height: context.scaledV(26)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: context.scaled(20),
                        color: AppColors.primary,
                      ),
                      SizedBox(width: context.scaled(10)),
                      _secondsLeft > 0
                          ? Text(
                              'Resend code in $_timerLabel',
                              style: AppTextStyles.authScreenSubtitle(context),
                            )
                          : TextButton(
                              onPressed: isLoading ? null : _handleResend,
                              child: Text(
                                'Resend code',
                                style: AppTextStyles.authLink(context),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: context.scaledV(48)),
                  AppIllustrationImage(
                    asset: AppAssets.artOtpEnvelope,
                    height: context.scaledV(170),
                    borderRadius: 0,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: context.scaledV(38)),
                  PrimaryButton(
                    onPressed: isLoading ? null : _handleContinue,
                    isLoading: isLoading,
                    label: 'Verify OTP',
                    height: context.scaled(54),
                    radius: context.scaled(16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact, required this.isEmail});

  final String contact;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: context.scaled(290)),
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(20),
          vertical: context.scaledV(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.scaled(16)),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isEmail
                ? Icon(
                    Icons.email_outlined,
                    size: context.scaled(22),
                    color: AppColors.primary,
                  )
                : const AppSvgPhoneIcon(color: AppColors.primary, size: 22),
            SizedBox(width: context.scaled(16)),
            Flexible(
              child: Text(
                contact,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.scaled(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpFields extends StatelessWidget {
  const _OtpFields({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final code = controller.text;
    return SizedBox(
      height: context.scaledV(62),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isFilled = index < code.length;
              final isActive = focusNode.hasFocus && index == code.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: context.scaled(48),
                height: context.scaledV(58),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.scaled(14)),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.cardBorder,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  isFilled ? code[index] : '-',
                  style: TextStyle(
                    fontSize: context.scaled(21),
                    fontWeight: FontWeight.w700,
                    color: isFilled
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                enableInteractiveSelection: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onSubmitted: (_) => focusNode.unfocus(),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
