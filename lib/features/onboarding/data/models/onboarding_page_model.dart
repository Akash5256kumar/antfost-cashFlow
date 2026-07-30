import '../../domain/entities/onboarding_page.dart';

/// Data-layer representation of [OnboardingPage].
/// Handles JSON serialisation / deserialisation and extends the domain entity.
class OnboardingPageModel extends OnboardingPage {
  const OnboardingPageModel({
    required super.title,
    required super.subtitle,
    required super.imagePath,
  });

  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  /// Deserialises an [OnboardingPageModel] from a JSON map.
  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imagePath: json['image_path'] as String? ?? '',
    );
  }

  /// Promotes a domain [OnboardingPage] entity to an [OnboardingPageModel].
  factory OnboardingPageModel.fromEntity(OnboardingPage entity) {
    return OnboardingPageModel(
      title: entity.title,
      subtitle: entity.subtitle,
      imagePath: entity.imagePath,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  /// Serialises this model to a JSON map suitable for local storage.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image_path': imagePath,
    };
  }
}
