import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wallet_repository.dart';

/// Adds funds to the user's wallet after validating the amount.
class AddFundsUseCase extends UseCase<bool, AddFundsParams> {
  final WalletRepository repository;

  const AddFundsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddFundsParams params) {
    if (params.amount <= 0) {
      return Future.value(
        const Left(ValidationFailure('Amount must be greater than zero.')),
      );
    }
    return repository.addFunds(params.amount);
  }
}

/// Parameters for [AddFundsUseCase].
class AddFundsParams extends Equatable {
  final double amount;

  const AddFundsParams({required this.amount});

  @override
  List<Object?> get props => [amount];
}
