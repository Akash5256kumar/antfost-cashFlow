import 'package:equatable/equatable.dart';

/// The types of documents accepted during KYC verification.
enum DocumentType {
  /// UAE Emirates ID (front and back).
  emiratesId,

  /// International passport.
  passport,

  /// Company trade license.
  tradeLicense,

  /// VAT registration certificate.
  vatCertificate,
}

/// Domain entity representing a single document submitted as part of KYC.
class KycDocument extends Equatable {
  /// The type/category of this document.
  final DocumentType type;

  /// Local file path (when selected from device) or remote URL (once uploaded).
  final String filePath;

  const KycDocument({
    required this.type,
    required this.filePath,
  });

  @override
  List<Object?> get props => [type, filePath];
}
