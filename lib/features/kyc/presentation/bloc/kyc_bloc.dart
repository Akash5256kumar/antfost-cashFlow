import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_kyc_status_use_case.dart';
import '../../domain/usecases/submit_kyc_use_case.dart';
import 'kyc_event.dart';
import 'kyc_state.dart';

/// Orchestrates all KYC-related flows.
///
/// Maps [KycEvent] subclasses to the appropriate use cases and translates
/// results into [KycState] variants for the UI to react to.
class KycBloc extends Bloc<KycEvent, KycState> {
  final GetKycStatusUseCase getKycStatusUseCase;
  final SubmitKycUseCase submitKycUseCase;

  KycBloc({
    required this.getKycStatusUseCase,
    required this.submitKycUseCase,
  }) : super(const KycInitial()) {
    on<FetchKycStatusEvent>(_onFetchKycStatus);
    on<SubmitKycEvent>(_onSubmitKyc);
    on<RetryKycEvent>(_onRetry);
  }

  // ---------------------------------------------------------------------------
  // Event handlers
  // ---------------------------------------------------------------------------

  /// Fetches the current KYC status and emits [KycStatusLoaded] or [KycError].
  Future<void> _onFetchKycStatus(
    FetchKycStatusEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(const KycLoading());

    final result = await getKycStatusUseCase(const NoParams());

    result.fold(
      (failure) => emit(KycError(_mapFailureToMessage(failure))),
      (status) => emit(KycStatusLoaded(status)),
    );
  }

  /// Submits the KYC application and emits [KycSubmitted] or [KycError].
  Future<void> _onSubmitKyc(
    SubmitKycEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(const KycSubmitting());

    final result = await submitKycUseCase(
      SubmitKycParams(
        documents: event.documents,
        fullName: event.fullName,
        emiratesId: event.emiratesId,
        tradeListNumber: event.tradeListNumber,
      ),
    );

    result.fold(
      (failure) => emit(KycError(_mapFailureToMessage(failure))),
      (_) => emit(const KycSubmitted()),
    );
  }

  /// Re-triggers a KYC status fetch after an error.
  Future<void> _onRetry(
    RetryKycEvent event,
    Emitter<KycState> emit,
  ) async {
    await _onFetchKycStatus(const FetchKycStatusEvent(), emit);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Converts a [Failure] into a user-facing error message.
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return failure.message;
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Something went wrong. Please try again.';
  }
}
