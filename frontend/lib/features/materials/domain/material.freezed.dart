// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Material {

 String get id; String get title; String? get description;@JsonKey(name: 'file_name') String get fileName;@JsonKey(name: 'file_size') int get fileSize;@JsonKey(name: 'mime_type') String get mimeType;@JsonKey(name: 'download_count') int get downloadCount;@JsonKey(name: 'author_id') String get authorId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Material
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialCopyWith<Material> get copyWith => _$MaterialCopyWithImpl<Material>(this as Material, _$identity);

  /// Serializes this Material to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Material&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,fileName,fileSize,mimeType,downloadCount,authorId,categoryId,createdAt,updatedAt);

@override
String toString() {
  return 'Material(id: $id, title: $title, description: $description, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, downloadCount: $downloadCount, authorId: $authorId, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MaterialCopyWith<$Res>  {
  factory $MaterialCopyWith(Material value, $Res Function(Material) _then) = _$MaterialCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_size') int fileSize,@JsonKey(name: 'mime_type') String mimeType,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'author_id') String authorId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$MaterialCopyWithImpl<$Res>
    implements $MaterialCopyWith<$Res> {
  _$MaterialCopyWithImpl(this._self, this._then);

  final Material _self;
  final $Res Function(Material) _then;

/// Create a copy of Material
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? fileName = null,Object? fileSize = null,Object? mimeType = null,Object? downloadCount = null,Object? authorId = null,Object? categoryId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Material].
extension MaterialPatterns on Material {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Material value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Material() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Material value)  $default,){
final _that = this;
switch (_that) {
case _Material():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Material value)?  $default,){
final _that = this;
switch (_that) {
case _Material() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int fileSize, @JsonKey(name: 'mime_type')  String mimeType, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Material() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.fileName,_that.fileSize,_that.mimeType,_that.downloadCount,_that.authorId,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int fileSize, @JsonKey(name: 'mime_type')  String mimeType, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Material():
return $default(_that.id,_that.title,_that.description,_that.fileName,_that.fileSize,_that.mimeType,_that.downloadCount,_that.authorId,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(name: 'file_name')  String fileName, @JsonKey(name: 'file_size')  int fileSize, @JsonKey(name: 'mime_type')  String mimeType, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'author_id')  String authorId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Material() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.fileName,_that.fileSize,_that.mimeType,_that.downloadCount,_that.authorId,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Material implements Material {
  const _Material({required this.id, required this.title, required this.description, @JsonKey(name: 'file_name') required this.fileName, @JsonKey(name: 'file_size') required this.fileSize, @JsonKey(name: 'mime_type') required this.mimeType, @JsonKey(name: 'download_count') required this.downloadCount, @JsonKey(name: 'author_id') required this.authorId, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Material.fromJson(Map<String, dynamic> json) => _$MaterialFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'file_name') final  String fileName;
@override@JsonKey(name: 'file_size') final  int fileSize;
@override@JsonKey(name: 'mime_type') final  String mimeType;
@override@JsonKey(name: 'download_count') final  int downloadCount;
@override@JsonKey(name: 'author_id') final  String authorId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Material
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialCopyWith<_Material> get copyWith => __$MaterialCopyWithImpl<_Material>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Material&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,fileName,fileSize,mimeType,downloadCount,authorId,categoryId,createdAt,updatedAt);

@override
String toString() {
  return 'Material(id: $id, title: $title, description: $description, fileName: $fileName, fileSize: $fileSize, mimeType: $mimeType, downloadCount: $downloadCount, authorId: $authorId, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MaterialCopyWith<$Res> implements $MaterialCopyWith<$Res> {
  factory _$MaterialCopyWith(_Material value, $Res Function(_Material) _then) = __$MaterialCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'file_name') String fileName,@JsonKey(name: 'file_size') int fileSize,@JsonKey(name: 'mime_type') String mimeType,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'author_id') String authorId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$MaterialCopyWithImpl<$Res>
    implements _$MaterialCopyWith<$Res> {
  __$MaterialCopyWithImpl(this._self, this._then);

  final _Material _self;
  final $Res Function(_Material) _then;

/// Create a copy of Material
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? fileName = null,Object? fileSize = null,Object? mimeType = null,Object? downloadCount = null,Object? authorId = null,Object? categoryId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Material(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
