enum VerifyAccountFlow { signUp, passwordRecovery }

enum CreateAccountEntryPoint { getStarted, signIn }

class VerifyAccountRouteArgs {
  const VerifyAccountRouteArgs({
    required this.contact,
    required this.isEmail,
    required this.flow,
    this.isBusiness = true,
  });

  final String contact;
  final bool isEmail;
  final VerifyAccountFlow flow;

  /// Which account type is being registered. Business KYC lands on Home with
  /// the verification state shown there.
  final bool isBusiness;
}

class CreateAccountRouteArgs {
  const CreateAccountRouteArgs({required this.entryPoint});

  final CreateAccountEntryPoint entryPoint;
}

class HomeRouteArgs {
  const HomeRouteArgs({this.verificationUnderReview = false});

  final bool verificationUnderReview;
}
