import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/transaction.dart';
import '../models/wallet_balance_model.dart';
import '../models/wallet_transaction_model.dart';

/// Contract for the remote wallet data source.
abstract class WalletRemoteDataSource {
  /// Returns the current [WalletBalanceModel] from the remote API.
  /// Throws [ServerException] on failure.
  Future<WalletBalanceModel> getWalletBalance();

  /// Returns the list of [WalletTransactionModel] from the remote API.
  /// Throws [ServerException] on failure.
  Future<List<WalletTransactionModel>> getTransactions();

  /// Adds [amount] AED to the wallet.
  /// Returns `true` on success. Throws [ServerException] on failure.
  Future<bool> addFunds(double amount);
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Dio/Retrofit once the API is ready.
// ---------------------------------------------------------------------------

/// Simulates a 300 ms network round-trip.
Future<void> _fakeDelay() => Future.delayed(const Duration(milliseconds: 300));

/// Simulates a slower 500 ms operation for fund additions.
Future<void> _fakeFundsDelay() =>
    Future.delayed(const Duration(milliseconds: 500));

/// Mock remote data source for development / testing purposes.
class MockWalletRemoteDataSource implements WalletRemoteDataSource {
  @override
  Future<WalletBalanceModel> getWalletBalance() async {
    await _fakeDelay();
    return const WalletBalanceModel(
      availableTokenM3: 854.5,
      reservedTokenM3: 75.5,
      totalTokenM3: 930.0,
      estimatedValueAed: 153450.0,
    );
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions() async {
    await _fakeDelay();
    return const [
      WalletTransactionModel(
        id: 'tx1',
        type: TransactionType.deposit,
        name: 'Wallet Deposit',
        subtitle: null,
        amount: 41250.0,
        isCredit: true,
        status: TransactionStatus.completed,
        date: '9 Feb 2026 10:00 AM',
      ),
      WalletTransactionModel(
        id: 'tx2',
        type: TransactionType.reserved,
        name: 'Order Payment Reserved',
        subtitle: 'AF-2026-02-000234',
        amount: 12457.5,
        isCredit: false,
        status: TransactionStatus.reserved,
        date: '8 Feb 2026 02:30 PM',
      ),
      WalletTransactionModel(
        id: 'tx3',
        type: TransactionType.orderPayment,
        name: 'Order Payment',
        subtitle: 'AF-2026-02-000233',
        amount: 24750.0,
        isCredit: false,
        status: TransactionStatus.completed,
        date: '7 Feb 2026 09:00 AM',
      ),
      WalletTransactionModel(
        id: 'tx4',
        type: TransactionType.deposit,
        name: 'Wallet Deposit',
        subtitle: null,
        amount: 25000.0,
        isCredit: true,
        status: TransactionStatus.completed,
        date: '5 Feb 2026 11:00 AM',
      ),
      WalletTransactionModel(
        id: 'tx5',
        type: TransactionType.orderPayment,
        name: 'Order Payment',
        subtitle: 'AF-2026-02-000232',
        amount: 18200.0,
        isCredit: false,
        status: TransactionStatus.completed,
        date: '3 Feb 2026 08:00 AM',
      ),
      WalletTransactionModel(
        id: 'tx6',
        type: TransactionType.refund,
        name: 'Order Refund',
        subtitle: 'AF-2026-02-000230',
        amount: 5500.0,
        isCredit: true,
        status: TransactionStatus.completed,
        date: '1 Feb 2026 03:00 PM',
      ),
    ];
  }

  @override
  Future<bool> addFunds(double amount) async {
    await _fakeFundsDelay();
    return true;
  }
}

class ApiWalletRemoteDataSource implements WalletRemoteDataSource {
  ApiWalletRemoteDataSource(this._client);
  final ApiClient _client;

  @override
  Future<WalletBalanceModel> getWalletBalance() => _request(() async {
    final response = await _client.get<Map<String, dynamic>>('/wallet/balance');
    if (response.data == null)
      throw const ServerException('Wallet balance response is invalid.');
    return WalletBalanceModel.fromJson(response.data!);
  });

  @override
  Future<List<WalletTransactionModel>> getTransactions() => _request(() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/wallet/transactions',
      queryParameters: const {'page': 1, 'pageSize': 100},
    );
    final items = response.data?['items'];
    if (items is! List)
      throw const ServerException('Wallet transactions response is invalid.');
    return items
        .whereType<Map>()
        .map(
          (item) =>
              WalletTransactionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  });

  @override
  Future<bool> addFunds(double amount) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/wallet/top-ups',
      data: {'amountAed': amount},
    );
    if (response.data?['topUpId'] == null)
      throw const ServerException('Top-up response is invalid.');
    return true;
  });

  Future<T> _request<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : error.message ?? 'Unable to reach the wallet service.';
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout)
        throw TimeoutException(message);
      if (error.type == DioExceptionType.connectionError)
        throw NetworkException(message);
      throw ServerException(message);
    }
  }
}
