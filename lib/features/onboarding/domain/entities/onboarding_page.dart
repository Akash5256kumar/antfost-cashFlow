import 'package:equatable/equatable.dart';

/// Domain entity representing a single slide in the onboarding flow.
class OnboardingPage extends Equatable {
  /// Main heading displayed on the slide.
  final String title;

  /// Supporting text shown below the title.
  final String subtitle;

  /// Asset path for the illustration displayed on the slide.
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, subtitle, imagePath];
}
