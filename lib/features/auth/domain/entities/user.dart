import 'package:equatable/equatable.dart';

/// Core domain entity representing an authenticated user.
/// Pure Dart — no Flutter or JSON imports.
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final bool isKycVerified;
  final String kycStatus;
  final String accountState;
  final bool canUseApp;
  final bool canCreateDraftOrders;
  final bool canSubmitOrders;
  final bool canMakePayments;
  final String? blockedMessage;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.isKycVerified,
    this.kycStatus = 'not_required',
    this.accountState = 'active',
    this.canUseApp = true,
    this.canCreateDraftOrders = true,
    this.canSubmitOrders = true,
    this.canMakePayments = true,
    this.blockedMessage,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    company,
    isKycVerified,
    kycStatus,
    accountState,
    canUseApp,
    canCreateDraftOrders,
    canSubmitOrders,
    canMakePayments,
    blockedMessage,
  ];
}
