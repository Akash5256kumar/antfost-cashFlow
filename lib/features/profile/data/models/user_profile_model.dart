import '../../domain/entities/user_profile.dart';

/// Data-layer model for [UserProfile]. Adds JSON serialisation.
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.company,
    super.avatarUrl,
    required super.isKycVerified,
  });

  /// Creates a [UserProfileModel] from a JSON map.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      company: json['company'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isKycVerified: json['isKycVerified'] as bool,
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'avatarUrl': avatarUrl,
      'isKycVerified': isKycVerified,
    };
  }

  /// Creates a [UserProfileModel] from a domain [UserProfile] entity.
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      company: entity.company,
      avatarUrl: entity.avatarUrl,
      isKycVerified: entity.isKycVerified,
    );
  }
}
