import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/initiate_payment_use_case.dart';
import '../../domain/usecases/verify_payment_use_case.dart';
import 'payment_event.dart';
import 'payment_state.dart';

/// BLoC responsible for the payment flow.
///
/// Flow on [InitiatePaymentEvent]:
///   1. Emit [PaymentLoading]
///   2. Call [InitiatePaymentUseCase]
///   3. On success → emit [PaymentProcessing]
///   4. Call [VerifyPaymentUseCase] with the returned payment id
///   5. On success → emit [PaymentSuccess]; on failure → emit [PaymentError]
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;

  PaymentBloc({
    required this.initiatePaymentUseCase,
    required this.verifyPaymentUseCase,
  }) : super(const PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<RetryPaymentEvent>(_onRetryPayment);
  }

  // -------------------------------------------------------------------------
  // Event handlers
  // -------------------------------------------------------------------------

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final initiateResult = await initiatePaymentUseCase(
      InitiatePaymentParams(
        orderId: event.orderId,
        amount: event.amount,
        method: event.method,
      ),
    );

    await initiateResult.fold(
      (failure) async => emit(PaymentError(failure.message)),
      (payment) async {
        // Initiation succeeded — move to processing state and verify.
        emit(const PaymentProcessing());

        final verifyResult = await verifyPaymentUseCase(
          VerifyPaymentParams(paymentId: payment.id),
        );

        verifyResult.fold(
          (failure) => emit(PaymentError(failure.message)),
          (verifiedPayment) => emit(PaymentSuccess(verifiedPayment)),
        );
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    final result = await verifyPaymentUseCase(
      VerifyPaymentParams(paymentId: event.paymentId),
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentSuccess(payment)),
    );
  }

  void _onRetryPayment(
    RetryPaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}
