import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet_balance.dart';

/// Base class for all wallet states.
sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any events have been dispatched.
class WalletInitial extends WalletState {
  const WalletInitial();
}

/// Emitted while the wallet data is being fetched.
class WalletLoading extends WalletState {
  const WalletLoading();
}

/// Emitted when both balance and transactions have loaded successfully.
class WalletSuccess extends WalletState {
  final WalletBalance balance;
  final List<WalletTransaction> transactions;

  const WalletSuccess({
    required this.balance,
    required this.transactions,
  });

  @override
  List<Object?> get props => [balance, transactions];
}

/// Emitted while a fund-addition request is in progress.
class WalletAddingFunds extends WalletState {
  const WalletAddingFunds();
}

/// Emitted when funds have been successfully added.
/// The BLoC will subsequently re-fetch the wallet data.
class WalletFundsAdded extends WalletState {
  const WalletFundsAdded();
}

/// Emitted when an operation fails.
class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
