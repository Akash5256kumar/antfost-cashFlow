import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

/// Retrieves the wallet transaction history for the authenticated user.
class GetTransactionsUseCase extends UseCase<List<WalletTransaction>, NoParams> {
  final WalletRepository repository;

  const GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WalletTransaction>>> call(NoParams params) {
    return repository.getTransactions();
  }
}
