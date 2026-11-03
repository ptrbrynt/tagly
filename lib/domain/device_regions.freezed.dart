// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_regions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservedRegion {

 ReservedRegionKind get kind; double get left; double get top; double get width; double get height;
/// Create a copy of ReservedRegion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservedRegionCopyWith<ReservedRegion> get copyWith => _$ReservedRegionCopyWithImpl<ReservedRegion>(this as ReservedRegion, _$identity);

  /// Serializes this ReservedRegion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReservedRegion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservedRegion&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.left, _this.left) || other.left == _this.left)&&(identical(other.top, _this.top) || other.top == _this.top)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReservedRegion;
  return Object.hash(runtimeType,_this.kind,_this.left,_this.top,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as ReservedRegion;
  return 'ReservedRegion(kind: ${_this.kind}, left: ${_this.left}, top: ${_this.top}, width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $ReservedRegionCopyWith<$Res>  {
  factory $ReservedRegionCopyWith(ReservedRegion value, $Res Function(ReservedRegion) _then) = _$ReservedRegionCopyWithImpl;
@useResult
$Res call({
 ReservedRegionKind kind, double left, double top, double width, double height
});




}
/// @nodoc
class _$ReservedRegionCopyWithImpl<$Res>
    implements $ReservedRegionCopyWith<$Res> {
  _$ReservedRegionCopyWithImpl(this._self, this._then);

  final ReservedRegion _self;
  final $Res Function(ReservedRegion) _then;

/// Create a copy of ReservedRegion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(ReservedRegion(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReservedRegionKind,left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservedRegion].
extension ReservedRegionPatterns on ReservedRegion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservedRegion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservedRegion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservedRegion value)  $default,){
final _that = this;
switch (_that) {
case _ReservedRegion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservedRegion value)?  $default,){
final _that = this;
switch (_that) {
case _ReservedRegion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReservedRegionKind kind,  double left,  double top,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservedRegion() when $default != null:
return $default(_that.kind,_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReservedRegionKind kind,  double left,  double top,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _ReservedRegion():
return $default(_that.kind,_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReservedRegionKind kind,  double left,  double top,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _ReservedRegion() when $default != null:
return $default(_that.kind,_that.left,_that.top,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservedRegion implements ReservedRegion {
  const _ReservedRegion({required this.kind, required this.left, required this.top, required this.width, required this.height});
  factory _ReservedRegion.fromJson(Map<String, dynamic> json) => _$ReservedRegionFromJson(json);

@override final  ReservedRegionKind kind;
@override final  double left;
@override final  double top;
@override final  double width;
@override final  double height;

/// Create a copy of ReservedRegion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservedRegionCopyWith<_ReservedRegion> get copyWith => __$ReservedRegionCopyWithImpl<_ReservedRegion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservedRegionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservedRegion&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,left,top,width,height);
}

@override
String toString() {
    return 'ReservedRegion(kind: $kind, left: $left, top: $top, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ReservedRegionCopyWith<$Res> implements $ReservedRegionCopyWith<$Res> {
  factory _$ReservedRegionCopyWith(_ReservedRegion value, $Res Function(_ReservedRegion) _then) = __$ReservedRegionCopyWithImpl;
@override @useResult
$Res call({
 ReservedRegionKind kind, double left, double top, double width, double height
});




}
/// @nodoc
class __$ReservedRegionCopyWithImpl<$Res>
    implements _$ReservedRegionCopyWith<$Res> {
  __$ReservedRegionCopyWithImpl(this._self, this._then);

  final _ReservedRegion _self;
  final $Res Function(_ReservedRegion) _then;

/// Create a copy of ReservedRegion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(_ReservedRegion(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReservedRegionKind,left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Hinge {

 HingeStatus get status; double get angle;
/// Create a copy of Hinge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HingeCopyWith<Hinge> get copyWith => _$HingeCopyWithImpl<Hinge>(this as Hinge, _$identity);

  /// Serializes this Hinge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Hinge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hinge&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.angle, _this.angle) || other.angle == _this.angle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Hinge;
  return Object.hash(runtimeType,_this.status,_this.angle);
}

@override
String toString() {
  final _this = this as Hinge;
  return 'Hinge(status: ${_this.status}, angle: ${_this.angle})';
}


}

/// @nodoc
abstract mixin class $HingeCopyWith<$Res>  {
  factory $HingeCopyWith(Hinge value, $Res Function(Hinge) _then) = _$HingeCopyWithImpl;
@useResult
$Res call({
 HingeStatus status, double angle
});




}
/// @nodoc
class _$HingeCopyWithImpl<$Res>
    implements $HingeCopyWith<$Res> {
  _$HingeCopyWithImpl(this._self, this._then);

  final Hinge _self;
  final $Res Function(Hinge) _then;

/// Create a copy of Hinge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? angle = null,}) {
  return _then(Hinge(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HingeStatus,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Hinge].
extension HingePatterns on Hinge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hinge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hinge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hinge value)  $default,){
final _that = this;
switch (_that) {
case _Hinge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hinge value)?  $default,){
final _that = this;
switch (_that) {
case _Hinge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HingeStatus status,  double angle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hinge() when $default != null:
return $default(_that.status,_that.angle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HingeStatus status,  double angle)  $default,) {final _that = this;
switch (_that) {
case _Hinge():
return $default(_that.status,_that.angle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HingeStatus status,  double angle)?  $default,) {final _that = this;
switch (_that) {
case _Hinge() when $default != null:
return $default(_that.status,_that.angle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hinge implements Hinge {
  const _Hinge({required this.status, required this.angle});
  factory _Hinge.fromJson(Map<String, dynamic> json) => _$HingeFromJson(json);

@override final  HingeStatus status;
@override final  double angle;

/// Create a copy of Hinge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HingeCopyWith<_Hinge> get copyWith => __$HingeCopyWithImpl<_Hinge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HingeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hinge&&(identical(other.status, status) || other.status == status)&&(identical(other.angle, angle) || other.angle == angle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,angle);
}

@override
String toString() {
    return 'Hinge(status: $status, angle: $angle)';
}


}

/// @nodoc
abstract mixin class _$HingeCopyWith<$Res> implements $HingeCopyWith<$Res> {
  factory _$HingeCopyWith(_Hinge value, $Res Function(_Hinge) _then) = __$HingeCopyWithImpl;
@override @useResult
$Res call({
 HingeStatus status, double angle
});




}
/// @nodoc
class __$HingeCopyWithImpl<$Res>
    implements _$HingeCopyWith<$Res> {
  __$HingeCopyWithImpl(this._self, this._then);

  final _Hinge _self;
  final $Res Function(_Hinge) _then;

/// Create a copy of Hinge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? angle = null,}) {
  return _then(_Hinge(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HingeStatus,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DeviceRegions {

 List<ReservedRegion> get regions; BarSide? get barSide; Hinge? get hinge;
/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegionsCopyWith<DeviceRegions> get copyWith => _$DeviceRegionsCopyWithImpl<DeviceRegions>(this as DeviceRegions, _$identity);

  /// Serializes this DeviceRegions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceRegions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegions&&const DeepCollectionEquality().equals(other.regions, _this.regions)&&(identical(other.barSide, _this.barSide) || other.barSide == _this.barSide)&&(identical(other.hinge, _this.hinge) || other.hinge == _this.hinge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceRegions;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.regions),_this.barSide,_this.hinge);
}

@override
String toString() {
  final _this = this as DeviceRegions;
  return 'DeviceRegions(regions: ${_this.regions}, barSide: ${_this.barSide}, hinge: ${_this.hinge})';
}


}

/// @nodoc
abstract mixin class $DeviceRegionsCopyWith<$Res>  {
  factory $DeviceRegionsCopyWith(DeviceRegions value, $Res Function(DeviceRegions) _then) = _$DeviceRegionsCopyWithImpl;
@useResult
$Res call({
 List<ReservedRegion> regions, BarSide? barSide, Hinge? hinge
});


$HingeCopyWith<$Res>? get hinge;

}
/// @nodoc
class _$DeviceRegionsCopyWithImpl<$Res>
    implements $DeviceRegionsCopyWith<$Res> {
  _$DeviceRegionsCopyWithImpl(this._self, this._then);

  final DeviceRegions _self;
  final $Res Function(DeviceRegions) _then;

/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? regions = null,Object? barSide = freezed,Object? hinge = freezed,}) {
  return _then(DeviceRegions(
regions: null == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as List<ReservedRegion>,barSide: freezed == barSide ? _self.barSide : barSide // ignore: cast_nullable_to_non_nullable
as BarSide?,hinge: freezed == hinge ? _self.hinge : hinge // ignore: cast_nullable_to_non_nullable
as Hinge?,
  ));
}
/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HingeCopyWith<$Res>? get hinge {
    if (_self.hinge == null) {
    return null;
  }

  return $HingeCopyWith<$Res>(_self.hinge!, (value) {
    return _then(_self.copyWith(hinge: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceRegions].
extension DeviceRegionsPatterns on DeviceRegions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegions value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegions value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReservedRegion> regions,  BarSide? barSide,  Hinge? hinge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegions() when $default != null:
return $default(_that.regions,_that.barSide,_that.hinge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReservedRegion> regions,  BarSide? barSide,  Hinge? hinge)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegions():
return $default(_that.regions,_that.barSide,_that.hinge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReservedRegion> regions,  BarSide? barSide,  Hinge? hinge)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegions() when $default != null:
return $default(_that.regions,_that.barSide,_that.hinge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegions implements DeviceRegions {
  const _DeviceRegions({ List<ReservedRegion> regions = const <ReservedRegion>[], this.barSide, this.hinge}): _regions = regions;
  factory _DeviceRegions.fromJson(Map<String, dynamic> json) => _$DeviceRegionsFromJson(json);

 final  List<ReservedRegion> _regions;
@override@JsonKey() List<ReservedRegion> get regions {
  if (_regions is EqualUnmodifiableListView) return _regions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_regions);
}

@override final  BarSide? barSide;
@override final  Hinge? hinge;

/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegionsCopyWith<_DeviceRegions> get copyWith => __$DeviceRegionsCopyWithImpl<_DeviceRegions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegions&&const DeepCollectionEquality().equals(other.regions, _regions)&&(identical(other.barSide, barSide) || other.barSide == barSide)&&(identical(other.hinge, hinge) || other.hinge == hinge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_regions),barSide,hinge);
}

@override
String toString() {
    return 'DeviceRegions(regions: $regions, barSide: $barSide, hinge: $hinge)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegionsCopyWith<$Res> implements $DeviceRegionsCopyWith<$Res> {
  factory _$DeviceRegionsCopyWith(_DeviceRegions value, $Res Function(_DeviceRegions) _then) = __$DeviceRegionsCopyWithImpl;
@override @useResult
$Res call({
 List<ReservedRegion> regions, BarSide? barSide, Hinge? hinge
});


@override $HingeCopyWith<$Res>? get hinge;

}
/// @nodoc
class __$DeviceRegionsCopyWithImpl<$Res>
    implements _$DeviceRegionsCopyWith<$Res> {
  __$DeviceRegionsCopyWithImpl(this._self, this._then);

  final _DeviceRegions _self;
  final $Res Function(_DeviceRegions) _then;

/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? regions = null,Object? barSide = freezed,Object? hinge = freezed,}) {
  return _then(_DeviceRegions(
regions: null == regions ? _self._regions : regions // ignore: cast_nullable_to_non_nullable
as List<ReservedRegion>,barSide: freezed == barSide ? _self.barSide : barSide // ignore: cast_nullable_to_non_nullable
as BarSide?,hinge: freezed == hinge ? _self.hinge : hinge // ignore: cast_nullable_to_non_nullable
as Hinge?,
  ));
}

/// Create a copy of DeviceRegions
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HingeCopyWith<$Res>? get hinge {
    if (_self.hinge == null) {
    return null;
  }

  return $HingeCopyWith<$Res>(_self.hinge!, (value) {
    return _then(_self.copyWith(hinge: value));
  });
}
}

// dart format on
