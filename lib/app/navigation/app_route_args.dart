enum VerifyAccountFlow { signUp, passwordRecovery }

enum CreateAccountEntryPoint { getStarted, signIn }

class VerifyAccountRouteArgs {
  const VerifyAccountRouteArgs({
    required this.contact,
    required this.isEmail,
    required this.flow,
  });

  final String contact;
  final bool isEmail;
  final VerifyAccountFlow flow;
}

class CreateAccountRouteArgs {
  const CreateAccountRouteArgs({required this.entryPoint});

  final CreateAccountEntryPoint entryPoint;
}
