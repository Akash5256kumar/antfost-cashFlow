import '../../core/services/project_location_api_service.dart';

enum VerifyAccountFlow { signUp, passwordRecovery, signIn }

class VerifyAccountRouteArgs {
  const VerifyAccountRouteArgs({
    required this.contact,
    required this.isEmail,
    required this.flow,
    this.isBusiness = true,
    this.verificationId = '',
    this.expiresAt,
    this.resendAvailableAt,
    this.countryCode,
  });

  final String contact;
  final String? countryCode;
  final bool isEmail;
  final VerifyAccountFlow flow;
  final String verificationId;
  final DateTime? expiresAt;
  final DateTime? resendAvailableAt;

  /// Which account type is being registered. Business KYC lands on Home with
  /// the verification state shown there.
  final bool isBusiness;
}

class HomeRouteArgs {
  const HomeRouteArgs({this.verificationUnderReview = false});

  final bool verificationUnderReview;
}

class ResetPasscodeRouteArgs {
  const ResetPasscodeRouteArgs({required this.resetToken});
  final String resetToken;
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({required this.projectId});
  final String projectId;
}

class AddLocationRouteArgs {
  const AddLocationRouteArgs({this.projectId, this.initialLocation});
  final String? projectId;
  
  /// The location to edit, if any.
  final SavedLocation? initialLocation;
}
