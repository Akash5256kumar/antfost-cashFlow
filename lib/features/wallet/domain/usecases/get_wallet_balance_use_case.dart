import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_balance.dart';
import '../repositories/wallet_repository.dart';

/// Retrieves the current wallet balance for the authenticated user.
class GetWalletBalanceUseCase extends UseCase<WalletBalance, NoParams> {
  final WalletRepository repository;

  const GetWalletBalanceUseCase(this.repository);

  @override
  Future<Either<Failure, WalletBalance>> call(NoParams params) {
    return repository.getWalletBalance();
  }
}
