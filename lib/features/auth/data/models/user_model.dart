import '../../domain/entities/user.dart';

/// Data-layer representation of [User].
/// Handles JSON serialisation / deserialisation and extends the domain entity.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.company,
    required super.isKycVerified,
    super.kycStatus,
    super.accountState,
    super.canUseApp,
    super.canCreateDraftOrders,
    super.canSubmitOrders,
    super.canMakePayments,
    super.blockedMessage,
  });

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Deserialises a [UserModel] from a JSON map returned by the remote API.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      company: json['company'] as String? ?? '',
      isKycVerified:
          json['isKycVerified'] as bool? ??
          json['is_kyc_verified'] as bool? ??
          (json['kyc'] == 'approved'),
      kycStatus:
          json['kycStatus'] as String? ??
          json['kyc'] as String? ??
          'not_required',
      accountState:
          json['accountState'] as String? ??
          (json['access'] as Map?)?['state'] as String? ??
          'active',
      canUseApp: (json['access'] as Map?)?['canUseApp'] as bool? ?? true,
      canCreateDraftOrders:
          (json['access'] as Map?)?['canCreateDraftOrders'] as bool? ?? true,
      canSubmitOrders:
          (json['access'] as Map?)?['canSubmitOrders'] as bool? ?? true,
      canMakePayments:
          (json['access'] as Map?)?['canMakePayments'] as bool? ?? true,
      blockedMessage: (json['access'] as Map?)?['blockedMessage'] as String?,
    );
  }

  /// Promotes a domain [User] entity to a [UserModel].
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      company: user.company,
      isKycVerified: user.isKycVerified,
      kycStatus: user.kycStatus,
      accountState: user.accountState,
      canUseApp: user.canUseApp,
      canCreateDraftOrders: user.canCreateDraftOrders,
      canSubmitOrders: user.canSubmitOrders,
      canMakePayments: user.canMakePayments,
      blockedMessage: user.blockedMessage,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a JSON map suitable for caching or the remote API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'is_kyc_verified': isKycVerified,
      'kycStatus': kycStatus,
      'accountState': accountState,
      'access': {
        'state': accountState,
        'canUseApp': canUseApp,
        'canCreateDraftOrders': canCreateDraftOrders,
        'canSubmitOrders': canSubmitOrders,
        'canMakePayments': canMakePayments,
        'blockedMessage': blockedMessage,
      },
    };
  }
}
