import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC that manages profile screen state.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<RetryProfileEvent>(_onRetryProfile);
  }

  /// Handles [FetchProfileEvent]: loads profile data and emits the result.
  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileSuccess(profile)),
    );
  }

  /// Handles [UpdateProfileEvent]: persists changes and emits the result.
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result =
        await updateProfileUseCase(UpdateProfileParams(event.profile));

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(const ProfileUpdateSuccess()),
    );
  }

  /// Handles [RetryProfileEvent] by re-running the fetch logic.
  Future<void> _onRetryProfile(
    RetryProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _onFetchProfile(const FetchProfileEvent(), emit);
  }
}
