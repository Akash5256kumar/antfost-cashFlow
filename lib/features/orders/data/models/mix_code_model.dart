import '../../domain/entities/mix_code.dart';

/// Data model that extends the [MixCode] domain entity.
/// Adds JSON serialisation and a factory to convert from the entity.
class MixCodeModel extends MixCode {
  const MixCodeModel({
    required super.code,
    required super.type,
    required super.pricePerM3,
  });

  // ── JSON de-serialisation ─────────────────────────────────────────────────

  factory MixCodeModel.fromJson(Map<String, dynamic> json) {
    return MixCodeModel(
      code: json['code'] as String,
      type: json['type'] as String,
      pricePerM3: (json['pricePerM3'] as num).toDouble(),
    );
  }

  // ── JSON serialisation ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'pricePerM3': pricePerM3,
    };
  }

  // ── Convert from domain entity ────────────────────────────────────────────

  factory MixCodeModel.fromEntity(MixCode mixCode) {
    return MixCodeModel(
      code: mixCode.code,
      type: mixCode.type,
      pricePerM3: mixCode.pricePerM3,
    );
  }
}
