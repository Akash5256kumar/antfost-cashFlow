import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet_balance.dart';
import '../../domain/usecases/add_funds_use_case.dart';
import '../../domain/usecases/get_transactions_use_case.dart';
import '../../domain/usecases/get_wallet_balance_use_case.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

/// BLoC responsible for the wallet screen.
///
/// On [FetchWalletDataEvent] it fetches balance and transactions in parallel
/// and only emits [WalletSuccess] when both succeed.
///
/// On [AddFundsEvent] it emits [WalletAddingFunds], performs the operation,
/// emits [WalletFundsAdded], then immediately re-fetches wallet data.
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalanceUseCase getWalletBalanceUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final AddFundsUseCase addFundsUseCase;

  WalletBloc({
    required this.getWalletBalanceUseCase,
    required this.getTransactionsUseCase,
    required this.addFundsUseCase,
  }) : super(const WalletInitial()) {
    on<FetchWalletDataEvent>(_onFetchWalletData);
    on<AddFundsEvent>(_onAddFunds);
    on<RetryWalletEvent>(_onRetryWallet);
  }

  // -------------------------------------------------------------------------
  // Event handlers
  // -------------------------------------------------------------------------

  Future<void> _onFetchWalletData(
    FetchWalletDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    // Run both requests in parallel for better performance.
    final results = await Future.wait([
      getWalletBalanceUseCase(const NoParams()),
      getTransactionsUseCase(const NoParams()),
    ]);

    final balanceResult = results[0] as Either<Failure, WalletBalance>;
    final transactionsResult = results[1] as Either<Failure, List<WalletTransaction>>;

    // Fold balance result first; if it fails, emit error immediately.
    balanceResult.fold(
      (failure) => emit(WalletError(failure.message)),
      (balance) {
        transactionsResult.fold(
          (failure) => emit(WalletError(failure.message)),
          (transactions) => emit(
            WalletSuccess(
              balance: balance,
              transactions: transactions,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddFunds(
    AddFundsEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletAddingFunds());

    final result = await addFundsUseCase(AddFundsParams(amount: event.amount));

    await result.fold(
      (failure) async => emit(WalletError(failure.message)),
      (_) async {
        emit(const WalletFundsAdded());
        // Re-fetch data so the UI reflects the new balance.
        await _onFetchWalletData(const FetchWalletDataEvent(), emit);
      },
    );
  }

  Future<void> _onRetryWallet(
    RetryWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    await _onFetchWalletData(const FetchWalletDataEvent(), emit);
  }
}
