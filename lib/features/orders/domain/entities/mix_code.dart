import 'package:equatable/equatable.dart';

/// Domain entity representing a concrete mix code / product specification.
/// Pure Dart — no Flutter or external framework imports.
class MixCode extends Equatable {
  final String code;
  final String type;
  final double pricePerM3;

  const MixCode({
    required this.code,
    required this.type,
    required this.pricePerM3,
  });

  @override
  List<Object?> get props => [code, type, pricePerM3];
}
