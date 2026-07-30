import '../../../../core/errors/exceptions.dart';
import '../models/wallet_balance_model.dart';
import '../models/wallet_transaction_model.dart';

/// Contract for the local wallet data source (cache layer).
abstract class WalletLocalDataSource {
  /// Returns the cached [WalletBalanceModel].
  /// Throws [CacheException] if no cached data exists.
  Future<WalletBalanceModel> getCachedWalletBalance();

  /// Stores [balance] in the in-memory cache.
  Future<void> cacheWalletBalance(WalletBalanceModel balance);

  /// Returns the cached list of [WalletTransactionModel].
  /// Throws [CacheException] if no cached data exists.
  Future<List<WalletTransactionModel>> getCachedTransactions();

  /// Stores [transactions] in the in-memory cache.
  Future<void> cacheTransactions(List<WalletTransactionModel> transactions);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Hive/SharedPreferences when wired.
// ---------------------------------------------------------------------------

/// In-memory mock local data source. Data is lost when the app restarts.
class MockWalletLocalDataSource implements WalletLocalDataSource {
  WalletBalanceModel? _cachedBalance;
  List<WalletTransactionModel>? _cachedTransactions;

  @override
  Future<WalletBalanceModel> getCachedWalletBalance() async {
    final balance = _cachedBalance;
    if (balance == null) {
      throw const CacheException('No cached wallet balance found.');
    }
    return balance;
  }

  @override
  Future<void> cacheWalletBalance(WalletBalanceModel balance) async {
    _cachedBalance = balance;
  }

  @override
  Future<List<WalletTransactionModel>> getCachedTransactions() async {
    final transactions = _cachedTransactions;
    if (transactions == null) {
      throw const CacheException('No cached transactions found.');
    }
    return transactions;
  }

  @override
  Future<void> cacheTransactions(
    List<WalletTransactionModel> transactions,
  ) async {
    _cachedTransactions = transactions;
  }
}
