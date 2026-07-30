import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

/// Base class for all profile BLoC events.
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

/// Triggers an initial or refresh load of the user's profile.
final class FetchProfileEvent extends ProfileEvent {
  const FetchProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers a profile update with new [profile] data.
final class UpdateProfileEvent extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Retries a previously failed profile operation.
final class RetryProfileEvent extends ProfileEvent {
  const RetryProfileEvent();

  @override
  List<Object?> get props => [];
}
