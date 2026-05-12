// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_search_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagSearchQuery {

 String? get text; List<String>? get voicings; List<int>? get numParts; TagSortOrder get sortOrder; int? get limit; bool? get isClassic;
/// Create a copy of TagSearchQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagSearchQueryCopyWith<TagSearchQuery> get copyWith => _$TagSearchQueryCopyWithImpl<TagSearchQuery>(this as TagSearchQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagSearchQuery&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.voicings, voicings)&&const DeepCollectionEquality().equals(other.numParts, numParts)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.isClassic, isClassic) || other.isClassic == isClassic));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(voicings),const DeepCollectionEquality().hash(numParts),sortOrder,limit,isClassic);

@override
String toString() {
  return 'TagSearchQuery(text: $text, voicings: $voicings, numParts: $numParts, sortOrder: $sortOrder, limit: $limit, isClassic: $isClassic)';
}


}

/// @nodoc
abstract mixin class $TagSearchQueryCopyWith<$Res>  {
  factory $TagSearchQueryCopyWith(TagSearchQuery value, $Res Function(TagSearchQuery) _then) = _$TagSearchQueryCopyWithImpl;
@useResult
$Res call({
 String? text, List<String>? voicings, List<int>? numParts, TagSortOrder sortOrder, int? limit, bool? isClassic
});




}
/// @nodoc
class _$TagSearchQueryCopyWithImpl<$Res>
    implements $TagSearchQueryCopyWith<$Res> {
  _$TagSearchQueryCopyWithImpl(this._self, this._then);

  final TagSearchQuery _self;
  final $Res Function(TagSearchQuery) _then;

/// Create a copy of TagSearchQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? voicings = freezed,Object? numParts = freezed,Object? sortOrder = null,Object? limit = freezed,Object? isClassic = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,voicings: freezed == voicings ? _self.voicings : voicings // ignore: cast_nullable_to_non_nullable
as List<String>?,numParts: freezed == numParts ? _self.numParts : numParts // ignore: cast_nullable_to_non_nullable
as List<int>?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as TagSortOrder,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,isClassic: freezed == isClassic ? _self.isClassic : isClassic // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [TagSearchQuery].
extension TagSearchQueryPatterns on TagSearchQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagSearchQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagSearchQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagSearchQuery value)  $default,){
final _that = this;
switch (_that) {
case _TagSearchQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagSearchQuery value)?  $default,){
final _that = this;
switch (_that) {
case _TagSearchQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  List<String>? voicings,  List<int>? numParts,  TagSortOrder sortOrder,  int? limit,  bool? isClassic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagSearchQuery() when $default != null:
return $default(_that.text,_that.voicings,_that.numParts,_that.sortOrder,_that.limit,_that.isClassic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  List<String>? voicings,  List<int>? numParts,  TagSortOrder sortOrder,  int? limit,  bool? isClassic)  $default,) {final _that = this;
switch (_that) {
case _TagSearchQuery():
return $default(_that.text,_that.voicings,_that.numParts,_that.sortOrder,_that.limit,_that.isClassic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  List<String>? voicings,  List<int>? numParts,  TagSortOrder sortOrder,  int? limit,  bool? isClassic)?  $default,) {final _that = this;
switch (_that) {
case _TagSearchQuery() when $default != null:
return $default(_that.text,_that.voicings,_that.numParts,_that.sortOrder,_that.limit,_that.isClassic);case _:
  return null;

}
}

}

/// @nodoc


class _TagSearchQuery extends TagSearchQuery {
  const _TagSearchQuery({this.text, final  List<String>? voicings, final  List<int>? numParts, this.sortOrder = TagSortOrder.downloadsDesc, this.limit, this.isClassic}): _voicings = voicings,_numParts = numParts,super._();
  

@override final  String? text;
 final  List<String>? _voicings;
@override List<String>? get voicings {
  final value = _voicings;
  if (value == null) return null;
  if (_voicings is EqualUnmodifiableListView) return _voicings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _numParts;
@override List<int>? get numParts {
  final value = _numParts;
  if (value == null) return null;
  if (_numParts is EqualUnmodifiableListView) return _numParts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  TagSortOrder sortOrder;
@override final  int? limit;
@override final  bool? isClassic;

/// Create a copy of TagSearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagSearchQueryCopyWith<_TagSearchQuery> get copyWith => __$TagSearchQueryCopyWithImpl<_TagSearchQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagSearchQuery&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._voicings, _voicings)&&const DeepCollectionEquality().equals(other._numParts, _numParts)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.isClassic, isClassic) || other.isClassic == isClassic));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_voicings),const DeepCollectionEquality().hash(_numParts),sortOrder,limit,isClassic);

@override
String toString() {
  return 'TagSearchQuery(text: $text, voicings: $voicings, numParts: $numParts, sortOrder: $sortOrder, limit: $limit, isClassic: $isClassic)';
}


}

/// @nodoc
abstract mixin class _$TagSearchQueryCopyWith<$Res> implements $TagSearchQueryCopyWith<$Res> {
  factory _$TagSearchQueryCopyWith(_TagSearchQuery value, $Res Function(_TagSearchQuery) _then) = __$TagSearchQueryCopyWithImpl;
@override @useResult
$Res call({
 String? text, List<String>? voicings, List<int>? numParts, TagSortOrder sortOrder, int? limit, bool? isClassic
});




}
/// @nodoc
class __$TagSearchQueryCopyWithImpl<$Res>
    implements _$TagSearchQueryCopyWith<$Res> {
  __$TagSearchQueryCopyWithImpl(this._self, this._then);

  final _TagSearchQuery _self;
  final $Res Function(_TagSearchQuery) _then;

/// Create a copy of TagSearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? voicings = freezed,Object? numParts = freezed,Object? sortOrder = null,Object? limit = freezed,Object? isClassic = freezed,}) {
  return _then(_TagSearchQuery(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,voicings: freezed == voicings ? _self._voicings : voicings // ignore: cast_nullable_to_non_nullable
as List<String>?,numParts: freezed == numParts ? _self._numParts : numParts // ignore: cast_nullable_to_non_nullable
as List<int>?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as TagSortOrder,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,isClassic: freezed == isClassic ? _self.isClassic : isClassic // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
