import 'package:equatable/equatable.dart';

/// Domain entity representing the current token balance of the user's wallet.
/// Amounts are expressed in m³ tokens; [estimatedValueAed] is the AED equivalent.
/// Pure Dart — no Flutter or JSON imports.
class WalletBalance extends Equatable {
  final double availableTokenM3;
  final double reservedTokenM3;
  final double totalTokenM3;
  final double estimatedValueAed;

  const WalletBalance({
    required this.availableTokenM3,
    required this.reservedTokenM3,
    required this.totalTokenM3,
    required this.estimatedValueAed,
  });

  @override
  List<Object?> get props => [
        availableTokenM3,
        reservedTokenM3,
        totalTokenM3,
        estimatedValueAed,
      ];
}
