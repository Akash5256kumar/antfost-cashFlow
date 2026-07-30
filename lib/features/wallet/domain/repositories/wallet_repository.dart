import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../entities/wallet_balance.dart';

/// Contract that the data layer must fulfil for wallet operations.
/// All methods return [Either] so callers handle failures explicitly.
abstract class WalletRepository {
  /// Returns the current wallet balance for the authenticated user.
  Future<Either<Failure, WalletBalance>> getWalletBalance();

  /// Returns the transaction history for the authenticated user.
  Future<Either<Failure, List<WalletTransaction>>> getTransactions();

  /// Adds [amount] AED to the wallet.
  /// Returns `true` on success.
  Future<Either<Failure, bool>> addFunds(double amount);
}
