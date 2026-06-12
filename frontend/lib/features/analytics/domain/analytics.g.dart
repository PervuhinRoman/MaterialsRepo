// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SummaryStats _$SummaryStatsFromJson(Map<String, dynamic> json) =>
    _SummaryStats(
      totalEvents: (json['total_events'] as num).toInt(),
      views: (json['views'] as num).toInt(),
      downloads: (json['downloads'] as num).toInt(),
      uploads: (json['uploads'] as num).toInt(),
    );

Map<String, dynamic> _$SummaryStatsToJson(_SummaryStats instance) =>
    <String, dynamic>{
      'total_events': instance.totalEvents,
      'views': instance.views,
      'downloads': instance.downloads,
      'uploads': instance.uploads,
    };

_TopMaterial _$TopMaterialFromJson(Map<String, dynamic> json) => _TopMaterial(
  materialId: json['material_id'] as String?,
  title: json['title'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$TopMaterialToJson(_TopMaterial instance) =>
    <String, dynamic>{
      'material_id': instance.materialId,
      'title': instance.title,
      'count': instance.count,
    };
