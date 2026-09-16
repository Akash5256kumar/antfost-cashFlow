import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/navigation/app_routes.dart';
import '../../core/utils/input_validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/route_feedback.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/auth_event.dart';
import 'presentation/bloc/auth_state.dart';

class ResetPasscodeScreen extends StatefulWidget {
  const ResetPasscodeScreen({super.key, required this.resetToken});
  final String resetToken;
  @override
  State<ResetPasscodeScreen> createState() => _ResetPasscodeScreenState();
}

class _ResetPasscodeScreenState extends State<ResetPasscodeScreen> {
  final _key = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  Map<String, String> _serverErrors = const {};
  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text != _confirm.text) {
      showAppSnackBar(context, 'Passwords do not match.');
      return;
    }
    if (!(_key.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      ResetPasscodeEvent(
        resetToken: widget.resetToken,
        newPasscode: _password.text,
      ),
    );
  }

  Future<void> _showResetSuccess() async {
    showAppSnackBar(context, 'Password reset successfully. Please sign in.');
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false);
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthPasscodeReset) {
        _showResetSuccess();
      }
      if (state is AuthError) {
        setState(() => _serverErrors = state.fields);
        showAppSnackBar(context, state.message);
      }
    },
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Set New Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Choose a new password for your account.'),
              const SizedBox(height: 24),
              AppTextField(
                label: 'NEW PASSWORD',
                controller: _password,
                errorText: _serverErrors['newPasscode'],
                onChanged: (_) => _clearServerError('newPasscode'),
                obscureText: true,
                validator: InputValidators.password,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'CONFIRM PASSWORD',
                controller: _confirm,
                obscureText: true,
                validator: (v) =>
                    InputValidators.confirmPassword(v, _password.text),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Save Password',
                isLoading: state is AuthLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _clearServerError(String field) {
    if (!_serverErrors.containsKey(field)) return;
    setState(() => _serverErrors = Map.of(_serverErrors)..remove(field));
  }
}
