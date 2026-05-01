// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barbershop_tag_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BarbershopTagVideo {

 int get id; int get tagId; String? get description; String? get sungKeyMode; String? get sungKeyTonic; bool get isMultitrack; String? get youtubeCode; String? get facebookUrl; String? get sungBy; String? get sungWebsite; String? get posted;
/// Create a copy of BarbershopTagVideo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarbershopTagVideoCopyWith<BarbershopTagVideo> get copyWith => _$BarbershopTagVideoCopyWithImpl<BarbershopTagVideo>(this as BarbershopTagVideo, _$identity);

  /// Serializes this BarbershopTagVideo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarbershopTagVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.description, description) || other.description == description)&&(identical(other.sungKeyMode, sungKeyMode) || other.sungKeyMode == sungKeyMode)&&(identical(other.sungKeyTonic, sungKeyTonic) || other.sungKeyTonic == sungKeyTonic)&&(identical(other.isMultitrack, isMultitrack) || other.isMultitrack == isMultitrack)&&(identical(other.youtubeCode, youtubeCode) || other.youtubeCode == youtubeCode)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.sungBy, sungBy) || other.sungBy == sungBy)&&(identical(other.sungWebsite, sungWebsite) || other.sungWebsite == sungWebsite)&&(identical(other.posted, posted) || other.posted == posted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tagId,description,sungKeyMode,sungKeyTonic,isMultitrack,youtubeCode,facebookUrl,sungBy,sungWebsite,posted);

@override
String toString() {
  return 'BarbershopTagVideo(id: $id, tagId: $tagId, description: $description, sungKeyMode: $sungKeyMode, sungKeyTonic: $sungKeyTonic, isMultitrack: $isMultitrack, youtubeCode: $youtubeCode, facebookUrl: $facebookUrl, sungBy: $sungBy, sungWebsite: $sungWebsite, posted: $posted)';
}


}

/// @nodoc
abstract mixin class $BarbershopTagVideoCopyWith<$Res>  {
  factory $BarbershopTagVideoCopyWith(BarbershopTagVideo value, $Res Function(BarbershopTagVideo) _then) = _$BarbershopTagVideoCopyWithImpl;
@useResult
$Res call({
 int id, int tagId, String? description, String? sungKeyMode, String? sungKeyTonic, bool isMultitrack, String? youtubeCode, String? facebookUrl, String? sungBy, String? sungWebsite, String? posted
});




}
/// @nodoc
class _$BarbershopTagVideoCopyWithImpl<$Res>
    implements $BarbershopTagVideoCopyWith<$Res> {
  _$BarbershopTagVideoCopyWithImpl(this._self, this._then);

  final BarbershopTagVideo _self;
  final $Res Function(BarbershopTagVideo) _then;

/// Create a copy of BarbershopTagVideo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tagId = null,Object? description = freezed,Object? sungKeyMode = freezed,Object? sungKeyTonic = freezed,Object? isMultitrack = null,Object? youtubeCode = freezed,Object? facebookUrl = freezed,Object? sungBy = freezed,Object? sungWebsite = freezed,Object? posted = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sungKeyMode: freezed == sungKeyMode ? _self.sungKeyMode : sungKeyMode // ignore: cast_nullable_to_non_nullable
as String?,sungKeyTonic: freezed == sungKeyTonic ? _self.sungKeyTonic : sungKeyTonic // ignore: cast_nullable_to_non_nullable
as String?,isMultitrack: null == isMultitrack ? _self.isMultitrack : isMultitrack // ignore: cast_nullable_to_non_nullable
as bool,youtubeCode: freezed == youtubeCode ? _self.youtubeCode : youtubeCode // ignore: cast_nullable_to_non_nullable
as String?,facebookUrl: freezed == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String?,sungBy: freezed == sungBy ? _self.sungBy : sungBy // ignore: cast_nullable_to_non_nullable
as String?,sungWebsite: freezed == sungWebsite ? _self.sungWebsite : sungWebsite // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BarbershopTagVideo].
extension BarbershopTagVideoPatterns on BarbershopTagVideo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarbershopTagVideo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarbershopTagVideo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarbershopTagVideo value)  $default,){
final _that = this;
switch (_that) {
case _BarbershopTagVideo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarbershopTagVideo value)?  $default,){
final _that = this;
switch (_that) {
case _BarbershopTagVideo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int tagId,  String? description,  String? sungKeyMode,  String? sungKeyTonic,  bool isMultitrack,  String? youtubeCode,  String? facebookUrl,  String? sungBy,  String? sungWebsite,  String? posted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarbershopTagVideo() when $default != null:
return $default(_that.id,_that.tagId,_that.description,_that.sungKeyMode,_that.sungKeyTonic,_that.isMultitrack,_that.youtubeCode,_that.facebookUrl,_that.sungBy,_that.sungWebsite,_that.posted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int tagId,  String? description,  String? sungKeyMode,  String? sungKeyTonic,  bool isMultitrack,  String? youtubeCode,  String? facebookUrl,  String? sungBy,  String? sungWebsite,  String? posted)  $default,) {final _that = this;
switch (_that) {
case _BarbershopTagVideo():
return $default(_that.id,_that.tagId,_that.description,_that.sungKeyMode,_that.sungKeyTonic,_that.isMultitrack,_that.youtubeCode,_that.facebookUrl,_that.sungBy,_that.sungWebsite,_that.posted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int tagId,  String? description,  String? sungKeyMode,  String? sungKeyTonic,  bool isMultitrack,  String? youtubeCode,  String? facebookUrl,  String? sungBy,  String? sungWebsite,  String? posted)?  $default,) {final _that = this;
switch (_that) {
case _BarbershopTagVideo() when $default != null:
return $default(_that.id,_that.tagId,_that.description,_that.sungKeyMode,_that.sungKeyTonic,_that.isMultitrack,_that.youtubeCode,_that.facebookUrl,_that.sungBy,_that.sungWebsite,_that.posted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarbershopTagVideo extends BarbershopTagVideo {
  const _BarbershopTagVideo({required this.id, required this.tagId, this.description, this.sungKeyMode, this.sungKeyTonic, this.isMultitrack = false, this.youtubeCode, this.facebookUrl, this.sungBy, this.sungWebsite, this.posted}): super._();
  factory _BarbershopTagVideo.fromJson(Map<String, dynamic> json) => _$BarbershopTagVideoFromJson(json);

@override final  int id;
@override final  int tagId;
@override final  String? description;
@override final  String? sungKeyMode;
@override final  String? sungKeyTonic;
@override@JsonKey() final  bool isMultitrack;
@override final  String? youtubeCode;
@override final  String? facebookUrl;
@override final  String? sungBy;
@override final  String? sungWebsite;
@override final  String? posted;

/// Create a copy of BarbershopTagVideo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarbershopTagVideoCopyWith<_BarbershopTagVideo> get copyWith => __$BarbershopTagVideoCopyWithImpl<_BarbershopTagVideo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarbershopTagVideoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarbershopTagVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.description, description) || other.description == description)&&(identical(other.sungKeyMode, sungKeyMode) || other.sungKeyMode == sungKeyMode)&&(identical(other.sungKeyTonic, sungKeyTonic) || other.sungKeyTonic == sungKeyTonic)&&(identical(other.isMultitrack, isMultitrack) || other.isMultitrack == isMultitrack)&&(identical(other.youtubeCode, youtubeCode) || other.youtubeCode == youtubeCode)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.sungBy, sungBy) || other.sungBy == sungBy)&&(identical(other.sungWebsite, sungWebsite) || other.sungWebsite == sungWebsite)&&(identical(other.posted, posted) || other.posted == posted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tagId,description,sungKeyMode,sungKeyTonic,isMultitrack,youtubeCode,facebookUrl,sungBy,sungWebsite,posted);

@override
String toString() {
  return 'BarbershopTagVideo(id: $id, tagId: $tagId, description: $description, sungKeyMode: $sungKeyMode, sungKeyTonic: $sungKeyTonic, isMultitrack: $isMultitrack, youtubeCode: $youtubeCode, facebookUrl: $facebookUrl, sungBy: $sungBy, sungWebsite: $sungWebsite, posted: $posted)';
}


}

/// @nodoc
abstract mixin class _$BarbershopTagVideoCopyWith<$Res> implements $BarbershopTagVideoCopyWith<$Res> {
  factory _$BarbershopTagVideoCopyWith(_BarbershopTagVideo value, $Res Function(_BarbershopTagVideo) _then) = __$BarbershopTagVideoCopyWithImpl;
@override @useResult
$Res call({
 int id, int tagId, String? description, String? sungKeyMode, String? sungKeyTonic, bool isMultitrack, String? youtubeCode, String? facebookUrl, String? sungBy, String? sungWebsite, String? posted
});




}
/// @nodoc
class __$BarbershopTagVideoCopyWithImpl<$Res>
    implements _$BarbershopTagVideoCopyWith<$Res> {
  __$BarbershopTagVideoCopyWithImpl(this._self, this._then);

  final _BarbershopTagVideo _self;
  final $Res Function(_BarbershopTagVideo) _then;

/// Create a copy of BarbershopTagVideo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tagId = null,Object? description = freezed,Object? sungKeyMode = freezed,Object? sungKeyTonic = freezed,Object? isMultitrack = null,Object? youtubeCode = freezed,Object? facebookUrl = freezed,Object? sungBy = freezed,Object? sungWebsite = freezed,Object? posted = freezed,}) {
  return _then(_BarbershopTagVideo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sungKeyMode: freezed == sungKeyMode ? _self.sungKeyMode : sungKeyMode // ignore: cast_nullable_to_non_nullable
as String?,sungKeyTonic: freezed == sungKeyTonic ? _self.sungKeyTonic : sungKeyTonic // ignore: cast_nullable_to_non_nullable
as String?,isMultitrack: null == isMultitrack ? _self.isMultitrack : isMultitrack // ignore: cast_nullable_to_non_nullable
as bool,youtubeCode: freezed == youtubeCode ? _self.youtubeCode : youtubeCode // ignore: cast_nullable_to_non_nullable
as String?,facebookUrl: freezed == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String?,sungBy: freezed == sungBy ? _self.sungBy : sungBy // ignore: cast_nullable_to_non_nullable
as String?,sungWebsite: freezed == sungWebsite ? _self.sungWebsite : sungWebsite // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
