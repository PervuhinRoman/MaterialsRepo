// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SummaryStats {

@JsonKey(name: 'total_events') int get totalEvents; int get views; int get downloads; int get uploads;
/// Create a copy of SummaryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryStatsCopyWith<SummaryStats> get copyWith => _$SummaryStatsCopyWithImpl<SummaryStats>(this as SummaryStats, _$identity);

  /// Serializes this SummaryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryStats&&(identical(other.totalEvents, totalEvents) || other.totalEvents == totalEvents)&&(identical(other.views, views) || other.views == views)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.uploads, uploads) || other.uploads == uploads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEvents,views,downloads,uploads);

@override
String toString() {
  return 'SummaryStats(totalEvents: $totalEvents, views: $views, downloads: $downloads, uploads: $uploads)';
}


}

/// @nodoc
abstract mixin class $SummaryStatsCopyWith<$Res>  {
  factory $SummaryStatsCopyWith(SummaryStats value, $Res Function(SummaryStats) _then) = _$SummaryStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_events') int totalEvents, int views, int downloads, int uploads
});




}
/// @nodoc
class _$SummaryStatsCopyWithImpl<$Res>
    implements $SummaryStatsCopyWith<$Res> {
  _$SummaryStatsCopyWithImpl(this._self, this._then);

  final SummaryStats _self;
  final $Res Function(SummaryStats) _then;

/// Create a copy of SummaryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEvents = null,Object? views = null,Object? downloads = null,Object? uploads = null,}) {
  return _then(_self.copyWith(
totalEvents: null == totalEvents ? _self.totalEvents : totalEvents // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,uploads: null == uploads ? _self.uploads : uploads // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SummaryStats].
extension SummaryStatsPatterns on SummaryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryStats value)  $default,){
final _that = this;
switch (_that) {
case _SummaryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryStats value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_events')  int totalEvents,  int views,  int downloads,  int uploads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryStats() when $default != null:
return $default(_that.totalEvents,_that.views,_that.downloads,_that.uploads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_events')  int totalEvents,  int views,  int downloads,  int uploads)  $default,) {final _that = this;
switch (_that) {
case _SummaryStats():
return $default(_that.totalEvents,_that.views,_that.downloads,_that.uploads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_events')  int totalEvents,  int views,  int downloads,  int uploads)?  $default,) {final _that = this;
switch (_that) {
case _SummaryStats() when $default != null:
return $default(_that.totalEvents,_that.views,_that.downloads,_that.uploads);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SummaryStats implements SummaryStats {
  const _SummaryStats({@JsonKey(name: 'total_events') required this.totalEvents, required this.views, required this.downloads, required this.uploads});
  factory _SummaryStats.fromJson(Map<String, dynamic> json) => _$SummaryStatsFromJson(json);

@override@JsonKey(name: 'total_events') final  int totalEvents;
@override final  int views;
@override final  int downloads;
@override final  int uploads;

/// Create a copy of SummaryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryStatsCopyWith<_SummaryStats> get copyWith => __$SummaryStatsCopyWithImpl<_SummaryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SummaryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryStats&&(identical(other.totalEvents, totalEvents) || other.totalEvents == totalEvents)&&(identical(other.views, views) || other.views == views)&&(identical(other.downloads, downloads) || other.downloads == downloads)&&(identical(other.uploads, uploads) || other.uploads == uploads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEvents,views,downloads,uploads);

@override
String toString() {
  return 'SummaryStats(totalEvents: $totalEvents, views: $views, downloads: $downloads, uploads: $uploads)';
}


}

/// @nodoc
abstract mixin class _$SummaryStatsCopyWith<$Res> implements $SummaryStatsCopyWith<$Res> {
  factory _$SummaryStatsCopyWith(_SummaryStats value, $Res Function(_SummaryStats) _then) = __$SummaryStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_events') int totalEvents, int views, int downloads, int uploads
});




}
/// @nodoc
class __$SummaryStatsCopyWithImpl<$Res>
    implements _$SummaryStatsCopyWith<$Res> {
  __$SummaryStatsCopyWithImpl(this._self, this._then);

  final _SummaryStats _self;
  final $Res Function(_SummaryStats) _then;

/// Create a copy of SummaryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEvents = null,Object? views = null,Object? downloads = null,Object? uploads = null,}) {
  return _then(_SummaryStats(
totalEvents: null == totalEvents ? _self.totalEvents : totalEvents // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,downloads: null == downloads ? _self.downloads : downloads // ignore: cast_nullable_to_non_nullable
as int,uploads: null == uploads ? _self.uploads : uploads // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TopMaterial {

@JsonKey(name: 'material_id') String? get materialId; String? get title; int get count;
/// Create a copy of TopMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopMaterialCopyWith<TopMaterial> get copyWith => _$TopMaterialCopyWithImpl<TopMaterial>(this as TopMaterial, _$identity);

  /// Serializes this TopMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopMaterial&&(identical(other.materialId, materialId) || other.materialId == materialId)&&(identical(other.title, title) || other.title == title)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,materialId,title,count);

@override
String toString() {
  return 'TopMaterial(materialId: $materialId, title: $title, count: $count)';
}


}

/// @nodoc
abstract mixin class $TopMaterialCopyWith<$Res>  {
  factory $TopMaterialCopyWith(TopMaterial value, $Res Function(TopMaterial) _then) = _$TopMaterialCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'material_id') String? materialId, String? title, int count
});




}
/// @nodoc
class _$TopMaterialCopyWithImpl<$Res>
    implements $TopMaterialCopyWith<$Res> {
  _$TopMaterialCopyWithImpl(this._self, this._then);

  final TopMaterial _self;
  final $Res Function(TopMaterial) _then;

/// Create a copy of TopMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? materialId = freezed,Object? title = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
materialId: freezed == materialId ? _self.materialId : materialId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopMaterial].
extension TopMaterialPatterns on TopMaterial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopMaterial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopMaterial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopMaterial value)  $default,){
final _that = this;
switch (_that) {
case _TopMaterial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopMaterial value)?  $default,){
final _that = this;
switch (_that) {
case _TopMaterial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'material_id')  String? materialId,  String? title,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopMaterial() when $default != null:
return $default(_that.materialId,_that.title,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'material_id')  String? materialId,  String? title,  int count)  $default,) {final _that = this;
switch (_that) {
case _TopMaterial():
return $default(_that.materialId,_that.title,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'material_id')  String? materialId,  String? title,  int count)?  $default,) {final _that = this;
switch (_that) {
case _TopMaterial() when $default != null:
return $default(_that.materialId,_that.title,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopMaterial implements TopMaterial {
  const _TopMaterial({@JsonKey(name: 'material_id') required this.materialId, required this.title, required this.count});
  factory _TopMaterial.fromJson(Map<String, dynamic> json) => _$TopMaterialFromJson(json);

@override@JsonKey(name: 'material_id') final  String? materialId;
@override final  String? title;
@override final  int count;

/// Create a copy of TopMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopMaterialCopyWith<_TopMaterial> get copyWith => __$TopMaterialCopyWithImpl<_TopMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopMaterial&&(identical(other.materialId, materialId) || other.materialId == materialId)&&(identical(other.title, title) || other.title == title)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,materialId,title,count);

@override
String toString() {
  return 'TopMaterial(materialId: $materialId, title: $title, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TopMaterialCopyWith<$Res> implements $TopMaterialCopyWith<$Res> {
  factory _$TopMaterialCopyWith(_TopMaterial value, $Res Function(_TopMaterial) _then) = __$TopMaterialCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'material_id') String? materialId, String? title, int count
});




}
/// @nodoc
class __$TopMaterialCopyWithImpl<$Res>
    implements _$TopMaterialCopyWith<$Res> {
  __$TopMaterialCopyWithImpl(this._self, this._then);

  final _TopMaterial _self;
  final $Res Function(_TopMaterial) _then;

/// Create a copy of TopMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? materialId = freezed,Object? title = freezed,Object? count = null,}) {
  return _then(_TopMaterial(
materialId: freezed == materialId ? _self.materialId : materialId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
