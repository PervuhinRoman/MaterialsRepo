import 'package:freezed_annotation/freezed_annotation.dart';

part 'material.freezed.dart';
part 'material.g.dart';

@freezed
abstract class Material with _$Material {
  const factory Material({
    required String id,
    required String title,
    required String? description,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') required String mimeType,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'author_username') required String? authorUsername,
    @JsonKey(name: 'author_email') required String? authorEmail,
    @JsonKey(name: 'category_id') required String? categoryId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime? updatedAt,
  }) = _Material;

  factory Material.fromJson(Map<String, dynamic> json) =>
      _$MaterialFromJson(json);
}
