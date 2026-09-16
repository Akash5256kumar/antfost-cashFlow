import 'package:equatable/equatable.dart';

/// Represents the authenticated user's profile information.
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;

  /// Optional URL to the user's avatar image.
  final String? avatarUrl;

  /// Whether the user has completed KYC verification.
  final bool isKycVerified;
  final String accountType;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    this.avatarUrl,
    required this.isKycVerified,
    this.accountType = 'individual',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    company,
    avatarUrl,
    isKycVerified,
    accountType,
  ];
}
