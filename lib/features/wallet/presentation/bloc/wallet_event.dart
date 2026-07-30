import 'package:equatable/equatable.dart';

/// Base class for all wallet events.
sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers a fetch of the wallet balance and transaction history.
class FetchWalletDataEvent extends WalletEvent {
  const FetchWalletDataEvent();
}

/// Triggers an add-funds operation for [amount] AED.
class AddFundsEvent extends WalletEvent {
  final double amount;

  const AddFundsEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Retries the last failed fetch.
class RetryWalletEvent extends WalletEvent {
  const RetryWalletEvent();
}
