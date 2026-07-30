import 'package:equatable/equatable.dart';

import '../../domain/entities/payment.dart';

/// Base class for all payment states.
sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any events have been dispatched.
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Emitted while the payment initiation request is in flight.
class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

/// Emitted after initiation succeeds and while the verification request is
/// in flight. The UI can show a "processing" indicator at this point.
class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

/// Emitted when the payment has been verified as successful.
class PaymentSuccess extends PaymentState {
  final Payment payment;

  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

/// Emitted when any payment operation fails.
class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
