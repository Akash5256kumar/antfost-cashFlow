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

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.isKycVerified,
  });

  @override
  List<Object?> get props => [id, name, email, phone, company, isKycVerified];
}
