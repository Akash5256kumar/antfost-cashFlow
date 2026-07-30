import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

/// Base class for all profile BLoC states.
sealed class ProfileState extends Equatable {
  const ProfileState();
}

/// The BLoC has not yet received any event.
final class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object?> get props => [];
}

/// A profile operation is in progress.
final class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object?> get props => [];
}

/// The profile was fetched successfully.
final class ProfileSuccess extends ProfileState {
  final UserProfile profile;

  const ProfileSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// The profile was updated successfully.
final class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess();

  @override
  List<Object?> get props => [];
}

/// A profile operation failed.
final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
