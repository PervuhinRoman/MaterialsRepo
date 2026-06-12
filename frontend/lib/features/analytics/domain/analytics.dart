import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics.freezed.dart';
part 'analytics.g.dart';

@freezed
abstract class SummaryStats with _$SummaryStats {
  const factory SummaryStats({
    @JsonKey(name: 'total_events') required int totalEvents,
    required int views,
    required int downloads,
    required int uploads,
  }) = _SummaryStats;

  factory SummaryStats.fromJson(Map<String, dynamic> json) =>
      _$SummaryStatsFromJson(json);
}

@freezed
abstract class TopMaterial with _$TopMaterial {
  const factory TopMaterial({
    @JsonKey(name: 'material_id') required String? materialId,
    required String? title,
    required int count,
  }) = _TopMaterial;

  factory TopMaterial.fromJson(Map<String, dynamic> json) =>
      _$TopMaterialFromJson(json);
}
