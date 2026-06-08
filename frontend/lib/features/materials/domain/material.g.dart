// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Material _$MaterialFromJson(Map<String, dynamic> json) => _Material(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  fileName: json['file_name'] as String,
  fileSize: (json['file_size'] as num).toInt(),
  mimeType: json['mime_type'] as String,
  downloadCount: (json['download_count'] as num).toInt(),
  authorId: json['author_id'] as String,
  categoryId: json['category_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MaterialToJson(_Material instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'file_name': instance.fileName,
  'file_size': instance.fileSize,
  'mime_type': instance.mimeType,
  'download_count': instance.downloadCount,
  'author_id': instance.authorId,
  'category_id': instance.categoryId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
