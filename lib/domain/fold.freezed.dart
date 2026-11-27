// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fold.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Fold {

 double get left; double get top; double get width; double get height; bool get isActive;
/// Create a copy of Fold
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoldCopyWith<Fold> get copyWith => _$FoldCopyWithImpl<Fold>(this as Fold, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Fold;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fold&&(identical(other.left, _this.left) || other.left == _this.left)&&(identical(other.top, _this.top) || other.top == _this.top)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as Fold;
  return Object.hash(runtimeType,_this.left,_this.top,_this.width,_this.height,_this.isActive);
}

@override
String toString() {
  final _this = this as Fold;
  return 'Fold(left: ${_this.left}, top: ${_this.top}, width: ${_this.width}, height: ${_this.height}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $FoldCopyWith<$Res>  {
  factory $FoldCopyWith(Fold value, $Res Function(Fold) _then) = _$FoldCopyWithImpl;
@useResult
$Res call({
 double left, double top, double width, double height, bool isActive
});




}
/// @nodoc
class _$FoldCopyWithImpl<$Res>
    implements $FoldCopyWith<$Res> {
  _$FoldCopyWithImpl(this._self, this._then);

  final Fold _self;
  final $Res Function(Fold) _then;

/// Create a copy of Fold
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,Object? isActive = null,}) {
  return _then(Fold(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Fold].
extension FoldPatterns on Fold {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fold value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fold() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fold value)  $default,){
final _that = this;
switch (_that) {
case _Fold():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fold value)?  $default,){
final _that = this;
switch (_that) {
case _Fold() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fold() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Fold():
return $default(_that.left,_that.top,_that.width,_that.height,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double left,  double top,  double width,  double height,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Fold() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _Fold implements Fold {
  const _Fold({required this.left, required this.top, required this.width, required this.height, required this.isActive});
  

@override final  double left;
@override final  double top;
@override final  double width;
@override final  double height;
@override final  bool isActive;

/// Create a copy of Fold
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoldCopyWith<_Fold> get copyWith => __$FoldCopyWithImpl<_Fold>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fold&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,left,top,width,height,isActive);
}

@override
String toString() {
    return 'Fold(left: $left, top: $top, width: $width, height: $height, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$FoldCopyWith<$Res> implements $FoldCopyWith<$Res> {
  factory _$FoldCopyWith(_Fold value, $Res Function(_Fold) _then) = __$FoldCopyWithImpl;
@override @useResult
$Res call({
 double left, double top, double width, double height, bool isActive
});




}
/// @nodoc
class __$FoldCopyWithImpl<$Res>
    implements _$FoldCopyWith<$Res> {
  __$FoldCopyWithImpl(this._self, this._then);

  final _Fold _self;
  final $Res Function(_Fold) _then;

/// Create a copy of Fold
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,Object? isActive = null,}) {
  return _then(_Fold(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
