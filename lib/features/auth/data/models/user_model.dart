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
  });

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Deserialises a [UserModel] from a JSON map returned by the remote API.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      company: json['company'] as String? ?? '',
      isKycVerified: json['is_kyc_verified'] as bool? ?? false,
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
    };
  }
}
