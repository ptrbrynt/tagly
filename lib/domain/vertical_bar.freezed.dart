// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vertical_bar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreenRect {

 double get left; double get top; double get width; double get height;
/// Create a copy of ScreenRect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenRectCopyWith<ScreenRect> get copyWith => _$ScreenRectCopyWithImpl<ScreenRect>(this as ScreenRect, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScreenRect;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenRect&&(identical(other.left, _this.left) || other.left == _this.left)&&(identical(other.top, _this.top) || other.top == _this.top)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}


@override
int get hashCode {
  final _this = this as ScreenRect;
  return Object.hash(runtimeType,_this.left,_this.top,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as ScreenRect;
  return 'ScreenRect(left: ${_this.left}, top: ${_this.top}, width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $ScreenRectCopyWith<$Res>  {
  factory $ScreenRectCopyWith(ScreenRect value, $Res Function(ScreenRect) _then) = _$ScreenRectCopyWithImpl;
@useResult
$Res call({
 double left, double top, double width, double height
});




}
/// @nodoc
class _$ScreenRectCopyWithImpl<$Res>
    implements $ScreenRectCopyWith<$Res> {
  _$ScreenRectCopyWithImpl(this._self, this._then);

  final ScreenRect _self;
  final $Res Function(ScreenRect) _then;

/// Create a copy of ScreenRect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(ScreenRect(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenRect].
extension ScreenRectPatterns on ScreenRect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenRect value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenRect() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenRect value)  $default,){
final _that = this;
switch (_that) {
case _ScreenRect():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenRect value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenRect() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenRect() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _ScreenRect():
return $default(_that.left,_that.top,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double left,  double top,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _ScreenRect() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _ScreenRect implements ScreenRect {
  const _ScreenRect({required this.left, required this.top, required this.width, required this.height});
  

@override final  double left;
@override final  double top;
@override final  double width;
@override final  double height;

/// Create a copy of ScreenRect
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenRectCopyWith<_ScreenRect> get copyWith => __$ScreenRectCopyWithImpl<_ScreenRect>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenRect&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode {
    return Object.hash(runtimeType,left,top,width,height);
}

@override
String toString() {
    return 'ScreenRect(left: $left, top: $top, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ScreenRectCopyWith<$Res> implements $ScreenRectCopyWith<$Res> {
  factory _$ScreenRectCopyWith(_ScreenRect value, $Res Function(_ScreenRect) _then) = __$ScreenRectCopyWithImpl;
@override @useResult
$Res call({
 double left, double top, double width, double height
});




}
/// @nodoc
class __$ScreenRectCopyWithImpl<$Res>
    implements _$ScreenRectCopyWith<$Res> {
  __$ScreenRectCopyWithImpl(this._self, this._then);

  final _ScreenRect _self;
  final $Res Function(_ScreenRect) _then;

/// Create a copy of ScreenRect
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,}) {
  return _then(_ScreenRect(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$VerticalBar {

 VerticalBarEdge get edge;/// Where the system places bar controls, centred on the status bar and
/// camera above it.
 ScreenRect get controls;
/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerticalBarCopyWith<VerticalBar> get copyWith => _$VerticalBarCopyWithImpl<VerticalBar>(this as VerticalBar, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VerticalBar;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerticalBar&&(identical(other.edge, _this.edge) || other.edge == _this.edge)&&(identical(other.controls, _this.controls) || other.controls == _this.controls));
}


@override
int get hashCode {
  final _this = this as VerticalBar;
  return Object.hash(runtimeType,_this.edge,_this.controls);
}

@override
String toString() {
  final _this = this as VerticalBar;
  return 'VerticalBar(edge: ${_this.edge}, controls: ${_this.controls})';
}


}

/// @nodoc
abstract mixin class $VerticalBarCopyWith<$Res>  {
  factory $VerticalBarCopyWith(VerticalBar value, $Res Function(VerticalBar) _then) = _$VerticalBarCopyWithImpl;
@useResult
$Res call({
 VerticalBarEdge edge, ScreenRect controls
});


$ScreenRectCopyWith<$Res> get controls;

}
/// @nodoc
class _$VerticalBarCopyWithImpl<$Res>
    implements $VerticalBarCopyWith<$Res> {
  _$VerticalBarCopyWithImpl(this._self, this._then);

  final VerticalBar _self;
  final $Res Function(VerticalBar) _then;

/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? edge = null,Object? controls = null,}) {
  return _then(VerticalBar(
edge: null == edge ? _self.edge : edge // ignore: cast_nullable_to_non_nullable
as VerticalBarEdge,controls: null == controls ? _self.controls : controls // ignore: cast_nullable_to_non_nullable
as ScreenRect,
  ));
}
/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenRectCopyWith<$Res> get controls {
  
  return $ScreenRectCopyWith<$Res>(_self.controls, (value) {
    return _then(_self.copyWith(controls: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerticalBar].
extension VerticalBarPatterns on VerticalBar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerticalBar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerticalBar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerticalBar value)  $default,){
final _that = this;
switch (_that) {
case _VerticalBar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerticalBar value)?  $default,){
final _that = this;
switch (_that) {
case _VerticalBar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerticalBarEdge edge,  ScreenRect controls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerticalBar() when $default != null:
return $default(_that.edge,_that.controls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerticalBarEdge edge,  ScreenRect controls)  $default,) {final _that = this;
switch (_that) {
case _VerticalBar():
return $default(_that.edge,_that.controls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerticalBarEdge edge,  ScreenRect controls)?  $default,) {final _that = this;
switch (_that) {
case _VerticalBar() when $default != null:
return $default(_that.edge,_that.controls);case _:
  return null;

}
}

}

/// @nodoc


class _VerticalBar implements VerticalBar {
  const _VerticalBar({required this.edge, required this.controls});
  

@override final  VerticalBarEdge edge;
/// Where the system places bar controls, centred on the status bar and
/// camera above it.
@override final  ScreenRect controls;

/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerticalBarCopyWith<_VerticalBar> get copyWith => __$VerticalBarCopyWithImpl<_VerticalBar>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerticalBar&&(identical(other.edge, edge) || other.edge == edge)&&(identical(other.controls, controls) || other.controls == controls));
}


@override
int get hashCode {
    return Object.hash(runtimeType,edge,controls);
}

@override
String toString() {
    return 'VerticalBar(edge: $edge, controls: $controls)';
}


}

/// @nodoc
abstract mixin class _$VerticalBarCopyWith<$Res> implements $VerticalBarCopyWith<$Res> {
  factory _$VerticalBarCopyWith(_VerticalBar value, $Res Function(_VerticalBar) _then) = __$VerticalBarCopyWithImpl;
@override @useResult
$Res call({
 VerticalBarEdge edge, ScreenRect controls
});


@override $ScreenRectCopyWith<$Res> get controls;

}
/// @nodoc
class __$VerticalBarCopyWithImpl<$Res>
    implements _$VerticalBarCopyWith<$Res> {
  __$VerticalBarCopyWithImpl(this._self, this._then);

  final _VerticalBar _self;
  final $Res Function(_VerticalBar) _then;

/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? edge = null,Object? controls = null,}) {
  return _then(_VerticalBar(
edge: null == edge ? _self.edge : edge // ignore: cast_nullable_to_non_nullable
as VerticalBarEdge,controls: null == controls ? _self.controls : controls // ignore: cast_nullable_to_non_nullable
as ScreenRect,
  ));
}

/// Create a copy of VerticalBar
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenRectCopyWith<$Res> get controls {
  
  return $ScreenRectCopyWith<$Res>(_self.controls, (value) {
    return _then(_self.copyWith(controls: value));
  });
}
}

// dart format on
