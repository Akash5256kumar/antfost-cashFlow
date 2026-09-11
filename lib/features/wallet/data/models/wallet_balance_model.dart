import '../../domain/entities/wallet_balance.dart';

/// Data-layer representation of [WalletBalance].
/// Handles JSON serialisation / deserialisation and extends the domain entity.
class WalletBalanceModel extends WalletBalance {
  const WalletBalanceModel({
    required super.availableTokenM3,
    required super.reservedTokenM3,
    required super.totalTokenM3,
    required super.estimatedValueAed,
  });

  /// Deserialises a [WalletBalanceModel] from a JSON map.
  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      availableTokenM3:
          (json['availableTokenM3'] as num? ??
                  json['available_token_m3'] as num?)
              ?.toDouble() ??
          0.0,
      reservedTokenM3:
          (json['reservedTokenM3'] as num? ?? json['reserved_token_m3'] as num?)
              ?.toDouble() ??
          0.0,
      totalTokenM3:
          (json['totalTokenM3'] as num? ?? json['total_token_m3'] as num?)
              ?.toDouble() ??
          0.0,
      estimatedValueAed:
          (json['estimatedValueAed'] as num? ??
                  json['estimated_value_aed'] as num?)
              ?.toDouble() ??
          0.0,
    );
  }

  /// Promotes a domain [WalletBalance] entity to a [WalletBalanceModel].
  factory WalletBalanceModel.fromEntity(WalletBalance balance) {
    return WalletBalanceModel(
      availableTokenM3: balance.availableTokenM3,
      reservedTokenM3: balance.reservedTokenM3,
      totalTokenM3: balance.totalTokenM3,
      estimatedValueAed: balance.estimatedValueAed,
    );
  }

  /// Serialises this model to a JSON map suitable for caching.
  Map<String, dynamic> toJson() {
    return {
      'available_token_m3': availableTokenM3,
      'reserved_token_m3': reservedTokenM3,
      'total_token_m3': totalTokenM3,
      'estimated_value_aed': estimatedValueAed,
    };
  }
}
