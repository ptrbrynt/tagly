// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barbershop_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BarbershopTag {

 int get id; String get title; String? get altTitle; String? get version; String? get keyMode; String? get keyTonic; int? get parts; String? get type; String? get recording; String? get teachVidUrl; String? get lyrics; String? get notes; String? get arranger; String? get arrWebsite; int? get arrangedYear; String? get sungBy; String? get sungWebsite; int? get sungYear; String? get quartet; String? get quartetWebsite; String? get teacher; String? get teacherWebsite; String? get provider; String? get providerWebsite; String? get posted; bool get isClassic; String? get collection; double? get rating; int? get ratingCount; int? get downloaded; String? get lastUpdated; String? get sheetMusicUrl; String? get sheetMusicType; String? get notationUrl; String? get notationType; String? get allPartsUrl; String? get bassUrl; String? get bariUrl; String? get leadUrl; String? get tenorUrl;// Not a column in the tags table — populated by the repository
// when fetching a single tag with its related videos.
 List<BarbershopTagVideo> get videos;
/// Create a copy of BarbershopTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarbershopTagCopyWith<BarbershopTag> get copyWith => _$BarbershopTagCopyWithImpl<BarbershopTag>(this as BarbershopTag, _$identity);

  /// Serializes this BarbershopTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarbershopTag&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.altTitle, altTitle) || other.altTitle == altTitle)&&(identical(other.version, version) || other.version == version)&&(identical(other.keyMode, keyMode) || other.keyMode == keyMode)&&(identical(other.keyTonic, keyTonic) || other.keyTonic == keyTonic)&&(identical(other.parts, parts) || other.parts == parts)&&(identical(other.type, type) || other.type == type)&&(identical(other.recording, recording) || other.recording == recording)&&(identical(other.teachVidUrl, teachVidUrl) || other.teachVidUrl == teachVidUrl)&&(identical(other.lyrics, lyrics) || other.lyrics == lyrics)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.arranger, arranger) || other.arranger == arranger)&&(identical(other.arrWebsite, arrWebsite) || other.arrWebsite == arrWebsite)&&(identical(other.arrangedYear, arrangedYear) || other.arrangedYear == arrangedYear)&&(identical(other.sungBy, sungBy) || other.sungBy == sungBy)&&(identical(other.sungWebsite, sungWebsite) || other.sungWebsite == sungWebsite)&&(identical(other.sungYear, sungYear) || other.sungYear == sungYear)&&(identical(other.quartet, quartet) || other.quartet == quartet)&&(identical(other.quartetWebsite, quartetWebsite) || other.quartetWebsite == quartetWebsite)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.teacherWebsite, teacherWebsite) || other.teacherWebsite == teacherWebsite)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerWebsite, providerWebsite) || other.providerWebsite == providerWebsite)&&(identical(other.posted, posted) || other.posted == posted)&&(identical(other.isClassic, isClassic) || other.isClassic == isClassic)&&(identical(other.collection, collection) || other.collection == collection)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.sheetMusicUrl, sheetMusicUrl) || other.sheetMusicUrl == sheetMusicUrl)&&(identical(other.sheetMusicType, sheetMusicType) || other.sheetMusicType == sheetMusicType)&&(identical(other.notationUrl, notationUrl) || other.notationUrl == notationUrl)&&(identical(other.notationType, notationType) || other.notationType == notationType)&&(identical(other.allPartsUrl, allPartsUrl) || other.allPartsUrl == allPartsUrl)&&(identical(other.bassUrl, bassUrl) || other.bassUrl == bassUrl)&&(identical(other.bariUrl, bariUrl) || other.bariUrl == bariUrl)&&(identical(other.leadUrl, leadUrl) || other.leadUrl == leadUrl)&&(identical(other.tenorUrl, tenorUrl) || other.tenorUrl == tenorUrl)&&const DeepCollectionEquality().equals(other.videos, videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,altTitle,version,keyMode,keyTonic,parts,type,recording,teachVidUrl,lyrics,notes,arranger,arrWebsite,arrangedYear,sungBy,sungWebsite,sungYear,quartet,quartetWebsite,teacher,teacherWebsite,provider,providerWebsite,posted,isClassic,collection,rating,ratingCount,downloaded,lastUpdated,sheetMusicUrl,sheetMusicType,notationUrl,notationType,allPartsUrl,bassUrl,bariUrl,leadUrl,tenorUrl,const DeepCollectionEquality().hash(videos)]);

@override
String toString() {
  return 'BarbershopTag(id: $id, title: $title, altTitle: $altTitle, version: $version, keyMode: $keyMode, keyTonic: $keyTonic, parts: $parts, type: $type, recording: $recording, teachVidUrl: $teachVidUrl, lyrics: $lyrics, notes: $notes, arranger: $arranger, arrWebsite: $arrWebsite, arrangedYear: $arrangedYear, sungBy: $sungBy, sungWebsite: $sungWebsite, sungYear: $sungYear, quartet: $quartet, quartetWebsite: $quartetWebsite, teacher: $teacher, teacherWebsite: $teacherWebsite, provider: $provider, providerWebsite: $providerWebsite, posted: $posted, isClassic: $isClassic, collection: $collection, rating: $rating, ratingCount: $ratingCount, downloaded: $downloaded, lastUpdated: $lastUpdated, sheetMusicUrl: $sheetMusicUrl, sheetMusicType: $sheetMusicType, notationUrl: $notationUrl, notationType: $notationType, allPartsUrl: $allPartsUrl, bassUrl: $bassUrl, bariUrl: $bariUrl, leadUrl: $leadUrl, tenorUrl: $tenorUrl, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $BarbershopTagCopyWith<$Res>  {
  factory $BarbershopTagCopyWith(BarbershopTag value, $Res Function(BarbershopTag) _then) = _$BarbershopTagCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? altTitle, String? version, String? keyMode, String? keyTonic, int? parts, String? type, String? recording, String? teachVidUrl, String? lyrics, String? notes, String? arranger, String? arrWebsite, int? arrangedYear, String? sungBy, String? sungWebsite, int? sungYear, String? quartet, String? quartetWebsite, String? teacher, String? teacherWebsite, String? provider, String? providerWebsite, String? posted, bool isClassic, String? collection, double? rating, int? ratingCount, int? downloaded, String? lastUpdated, String? sheetMusicUrl, String? sheetMusicType, String? notationUrl, String? notationType, String? allPartsUrl, String? bassUrl, String? bariUrl, String? leadUrl, String? tenorUrl, List<BarbershopTagVideo> videos
});




}
/// @nodoc
class _$BarbershopTagCopyWithImpl<$Res>
    implements $BarbershopTagCopyWith<$Res> {
  _$BarbershopTagCopyWithImpl(this._self, this._then);

  final BarbershopTag _self;
  final $Res Function(BarbershopTag) _then;

/// Create a copy of BarbershopTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? altTitle = freezed,Object? version = freezed,Object? keyMode = freezed,Object? keyTonic = freezed,Object? parts = freezed,Object? type = freezed,Object? recording = freezed,Object? teachVidUrl = freezed,Object? lyrics = freezed,Object? notes = freezed,Object? arranger = freezed,Object? arrWebsite = freezed,Object? arrangedYear = freezed,Object? sungBy = freezed,Object? sungWebsite = freezed,Object? sungYear = freezed,Object? quartet = freezed,Object? quartetWebsite = freezed,Object? teacher = freezed,Object? teacherWebsite = freezed,Object? provider = freezed,Object? providerWebsite = freezed,Object? posted = freezed,Object? isClassic = null,Object? collection = freezed,Object? rating = freezed,Object? ratingCount = freezed,Object? downloaded = freezed,Object? lastUpdated = freezed,Object? sheetMusicUrl = freezed,Object? sheetMusicType = freezed,Object? notationUrl = freezed,Object? notationType = freezed,Object? allPartsUrl = freezed,Object? bassUrl = freezed,Object? bariUrl = freezed,Object? leadUrl = freezed,Object? tenorUrl = freezed,Object? videos = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,altTitle: freezed == altTitle ? _self.altTitle : altTitle // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,keyMode: freezed == keyMode ? _self.keyMode : keyMode // ignore: cast_nullable_to_non_nullable
as String?,keyTonic: freezed == keyTonic ? _self.keyTonic : keyTonic // ignore: cast_nullable_to_non_nullable
as String?,parts: freezed == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,recording: freezed == recording ? _self.recording : recording // ignore: cast_nullable_to_non_nullable
as String?,teachVidUrl: freezed == teachVidUrl ? _self.teachVidUrl : teachVidUrl // ignore: cast_nullable_to_non_nullable
as String?,lyrics: freezed == lyrics ? _self.lyrics : lyrics // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,arranger: freezed == arranger ? _self.arranger : arranger // ignore: cast_nullable_to_non_nullable
as String?,arrWebsite: freezed == arrWebsite ? _self.arrWebsite : arrWebsite // ignore: cast_nullable_to_non_nullable
as String?,arrangedYear: freezed == arrangedYear ? _self.arrangedYear : arrangedYear // ignore: cast_nullable_to_non_nullable
as int?,sungBy: freezed == sungBy ? _self.sungBy : sungBy // ignore: cast_nullable_to_non_nullable
as String?,sungWebsite: freezed == sungWebsite ? _self.sungWebsite : sungWebsite // ignore: cast_nullable_to_non_nullable
as String?,sungYear: freezed == sungYear ? _self.sungYear : sungYear // ignore: cast_nullable_to_non_nullable
as int?,quartet: freezed == quartet ? _self.quartet : quartet // ignore: cast_nullable_to_non_nullable
as String?,quartetWebsite: freezed == quartetWebsite ? _self.quartetWebsite : quartetWebsite // ignore: cast_nullable_to_non_nullable
as String?,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as String?,teacherWebsite: freezed == teacherWebsite ? _self.teacherWebsite : teacherWebsite // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,providerWebsite: freezed == providerWebsite ? _self.providerWebsite : providerWebsite // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as String?,isClassic: null == isClassic ? _self.isClassic : isClassic // ignore: cast_nullable_to_non_nullable
as bool,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,downloaded: freezed == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as int?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,sheetMusicUrl: freezed == sheetMusicUrl ? _self.sheetMusicUrl : sheetMusicUrl // ignore: cast_nullable_to_non_nullable
as String?,sheetMusicType: freezed == sheetMusicType ? _self.sheetMusicType : sheetMusicType // ignore: cast_nullable_to_non_nullable
as String?,notationUrl: freezed == notationUrl ? _self.notationUrl : notationUrl // ignore: cast_nullable_to_non_nullable
as String?,notationType: freezed == notationType ? _self.notationType : notationType // ignore: cast_nullable_to_non_nullable
as String?,allPartsUrl: freezed == allPartsUrl ? _self.allPartsUrl : allPartsUrl // ignore: cast_nullable_to_non_nullable
as String?,bassUrl: freezed == bassUrl ? _self.bassUrl : bassUrl // ignore: cast_nullable_to_non_nullable
as String?,bariUrl: freezed == bariUrl ? _self.bariUrl : bariUrl // ignore: cast_nullable_to_non_nullable
as String?,leadUrl: freezed == leadUrl ? _self.leadUrl : leadUrl // ignore: cast_nullable_to_non_nullable
as String?,tenorUrl: freezed == tenorUrl ? _self.tenorUrl : tenorUrl // ignore: cast_nullable_to_non_nullable
as String?,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<BarbershopTagVideo>,
  ));
}

}


/// Adds pattern-matching-related methods to [BarbershopTag].
extension BarbershopTagPatterns on BarbershopTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarbershopTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarbershopTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarbershopTag value)  $default,){
final _that = this;
switch (_that) {
case _BarbershopTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarbershopTag value)?  $default,){
final _that = this;
switch (_that) {
case _BarbershopTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? altTitle,  String? version,  String? keyMode,  String? keyTonic,  int? parts,  String? type,  String? recording,  String? teachVidUrl,  String? lyrics,  String? notes,  String? arranger,  String? arrWebsite,  int? arrangedYear,  String? sungBy,  String? sungWebsite,  int? sungYear,  String? quartet,  String? quartetWebsite,  String? teacher,  String? teacherWebsite,  String? provider,  String? providerWebsite,  String? posted,  bool isClassic,  String? collection,  double? rating,  int? ratingCount,  int? downloaded,  String? lastUpdated,  String? sheetMusicUrl,  String? sheetMusicType,  String? notationUrl,  String? notationType,  String? allPartsUrl,  String? bassUrl,  String? bariUrl,  String? leadUrl,  String? tenorUrl,  List<BarbershopTagVideo> videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarbershopTag() when $default != null:
return $default(_that.id,_that.title,_that.altTitle,_that.version,_that.keyMode,_that.keyTonic,_that.parts,_that.type,_that.recording,_that.teachVidUrl,_that.lyrics,_that.notes,_that.arranger,_that.arrWebsite,_that.arrangedYear,_that.sungBy,_that.sungWebsite,_that.sungYear,_that.quartet,_that.quartetWebsite,_that.teacher,_that.teacherWebsite,_that.provider,_that.providerWebsite,_that.posted,_that.isClassic,_that.collection,_that.rating,_that.ratingCount,_that.downloaded,_that.lastUpdated,_that.sheetMusicUrl,_that.sheetMusicType,_that.notationUrl,_that.notationType,_that.allPartsUrl,_that.bassUrl,_that.bariUrl,_that.leadUrl,_that.tenorUrl,_that.videos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? altTitle,  String? version,  String? keyMode,  String? keyTonic,  int? parts,  String? type,  String? recording,  String? teachVidUrl,  String? lyrics,  String? notes,  String? arranger,  String? arrWebsite,  int? arrangedYear,  String? sungBy,  String? sungWebsite,  int? sungYear,  String? quartet,  String? quartetWebsite,  String? teacher,  String? teacherWebsite,  String? provider,  String? providerWebsite,  String? posted,  bool isClassic,  String? collection,  double? rating,  int? ratingCount,  int? downloaded,  String? lastUpdated,  String? sheetMusicUrl,  String? sheetMusicType,  String? notationUrl,  String? notationType,  String? allPartsUrl,  String? bassUrl,  String? bariUrl,  String? leadUrl,  String? tenorUrl,  List<BarbershopTagVideo> videos)  $default,) {final _that = this;
switch (_that) {
case _BarbershopTag():
return $default(_that.id,_that.title,_that.altTitle,_that.version,_that.keyMode,_that.keyTonic,_that.parts,_that.type,_that.recording,_that.teachVidUrl,_that.lyrics,_that.notes,_that.arranger,_that.arrWebsite,_that.arrangedYear,_that.sungBy,_that.sungWebsite,_that.sungYear,_that.quartet,_that.quartetWebsite,_that.teacher,_that.teacherWebsite,_that.provider,_that.providerWebsite,_that.posted,_that.isClassic,_that.collection,_that.rating,_that.ratingCount,_that.downloaded,_that.lastUpdated,_that.sheetMusicUrl,_that.sheetMusicType,_that.notationUrl,_that.notationType,_that.allPartsUrl,_that.bassUrl,_that.bariUrl,_that.leadUrl,_that.tenorUrl,_that.videos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? altTitle,  String? version,  String? keyMode,  String? keyTonic,  int? parts,  String? type,  String? recording,  String? teachVidUrl,  String? lyrics,  String? notes,  String? arranger,  String? arrWebsite,  int? arrangedYear,  String? sungBy,  String? sungWebsite,  int? sungYear,  String? quartet,  String? quartetWebsite,  String? teacher,  String? teacherWebsite,  String? provider,  String? providerWebsite,  String? posted,  bool isClassic,  String? collection,  double? rating,  int? ratingCount,  int? downloaded,  String? lastUpdated,  String? sheetMusicUrl,  String? sheetMusicType,  String? notationUrl,  String? notationType,  String? allPartsUrl,  String? bassUrl,  String? bariUrl,  String? leadUrl,  String? tenorUrl,  List<BarbershopTagVideo> videos)?  $default,) {final _that = this;
switch (_that) {
case _BarbershopTag() when $default != null:
return $default(_that.id,_that.title,_that.altTitle,_that.version,_that.keyMode,_that.keyTonic,_that.parts,_that.type,_that.recording,_that.teachVidUrl,_that.lyrics,_that.notes,_that.arranger,_that.arrWebsite,_that.arrangedYear,_that.sungBy,_that.sungWebsite,_that.sungYear,_that.quartet,_that.quartetWebsite,_that.teacher,_that.teacherWebsite,_that.provider,_that.providerWebsite,_that.posted,_that.isClassic,_that.collection,_that.rating,_that.ratingCount,_that.downloaded,_that.lastUpdated,_that.sheetMusicUrl,_that.sheetMusicType,_that.notationUrl,_that.notationType,_that.allPartsUrl,_that.bassUrl,_that.bariUrl,_that.leadUrl,_that.tenorUrl,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BarbershopTag extends BarbershopTag {
  const _BarbershopTag({required this.id, required this.title, this.altTitle, this.version, this.keyMode, this.keyTonic, this.parts, this.type, this.recording, this.teachVidUrl, this.lyrics, this.notes, this.arranger, this.arrWebsite, this.arrangedYear, this.sungBy, this.sungWebsite, this.sungYear, this.quartet, this.quartetWebsite, this.teacher, this.teacherWebsite, this.provider, this.providerWebsite, this.posted, this.isClassic = false, this.collection, this.rating, this.ratingCount, this.downloaded, this.lastUpdated, this.sheetMusicUrl, this.sheetMusicType, this.notationUrl, this.notationType, this.allPartsUrl, this.bassUrl, this.bariUrl, this.leadUrl, this.tenorUrl, final  List<BarbershopTagVideo> videos = const []}): _videos = videos,super._();
  factory _BarbershopTag.fromJson(Map<String, dynamic> json) => _$BarbershopTagFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? altTitle;
@override final  String? version;
@override final  String? keyMode;
@override final  String? keyTonic;
@override final  int? parts;
@override final  String? type;
@override final  String? recording;
@override final  String? teachVidUrl;
@override final  String? lyrics;
@override final  String? notes;
@override final  String? arranger;
@override final  String? arrWebsite;
@override final  int? arrangedYear;
@override final  String? sungBy;
@override final  String? sungWebsite;
@override final  int? sungYear;
@override final  String? quartet;
@override final  String? quartetWebsite;
@override final  String? teacher;
@override final  String? teacherWebsite;
@override final  String? provider;
@override final  String? providerWebsite;
@override final  String? posted;
@override@JsonKey() final  bool isClassic;
@override final  String? collection;
@override final  double? rating;
@override final  int? ratingCount;
@override final  int? downloaded;
@override final  String? lastUpdated;
@override final  String? sheetMusicUrl;
@override final  String? sheetMusicType;
@override final  String? notationUrl;
@override final  String? notationType;
@override final  String? allPartsUrl;
@override final  String? bassUrl;
@override final  String? bariUrl;
@override final  String? leadUrl;
@override final  String? tenorUrl;
// Not a column in the tags table — populated by the repository
// when fetching a single tag with its related videos.
 final  List<BarbershopTagVideo> _videos;
// Not a column in the tags table — populated by the repository
// when fetching a single tag with its related videos.
@override@JsonKey() List<BarbershopTagVideo> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of BarbershopTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarbershopTagCopyWith<_BarbershopTag> get copyWith => __$BarbershopTagCopyWithImpl<_BarbershopTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BarbershopTagToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarbershopTag&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.altTitle, altTitle) || other.altTitle == altTitle)&&(identical(other.version, version) || other.version == version)&&(identical(other.keyMode, keyMode) || other.keyMode == keyMode)&&(identical(other.keyTonic, keyTonic) || other.keyTonic == keyTonic)&&(identical(other.parts, parts) || other.parts == parts)&&(identical(other.type, type) || other.type == type)&&(identical(other.recording, recording) || other.recording == recording)&&(identical(other.teachVidUrl, teachVidUrl) || other.teachVidUrl == teachVidUrl)&&(identical(other.lyrics, lyrics) || other.lyrics == lyrics)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.arranger, arranger) || other.arranger == arranger)&&(identical(other.arrWebsite, arrWebsite) || other.arrWebsite == arrWebsite)&&(identical(other.arrangedYear, arrangedYear) || other.arrangedYear == arrangedYear)&&(identical(other.sungBy, sungBy) || other.sungBy == sungBy)&&(identical(other.sungWebsite, sungWebsite) || other.sungWebsite == sungWebsite)&&(identical(other.sungYear, sungYear) || other.sungYear == sungYear)&&(identical(other.quartet, quartet) || other.quartet == quartet)&&(identical(other.quartetWebsite, quartetWebsite) || other.quartetWebsite == quartetWebsite)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.teacherWebsite, teacherWebsite) || other.teacherWebsite == teacherWebsite)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerWebsite, providerWebsite) || other.providerWebsite == providerWebsite)&&(identical(other.posted, posted) || other.posted == posted)&&(identical(other.isClassic, isClassic) || other.isClassic == isClassic)&&(identical(other.collection, collection) || other.collection == collection)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.sheetMusicUrl, sheetMusicUrl) || other.sheetMusicUrl == sheetMusicUrl)&&(identical(other.sheetMusicType, sheetMusicType) || other.sheetMusicType == sheetMusicType)&&(identical(other.notationUrl, notationUrl) || other.notationUrl == notationUrl)&&(identical(other.notationType, notationType) || other.notationType == notationType)&&(identical(other.allPartsUrl, allPartsUrl) || other.allPartsUrl == allPartsUrl)&&(identical(other.bassUrl, bassUrl) || other.bassUrl == bassUrl)&&(identical(other.bariUrl, bariUrl) || other.bariUrl == bariUrl)&&(identical(other.leadUrl, leadUrl) || other.leadUrl == leadUrl)&&(identical(other.tenorUrl, tenorUrl) || other.tenorUrl == tenorUrl)&&const DeepCollectionEquality().equals(other._videos, _videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,altTitle,version,keyMode,keyTonic,parts,type,recording,teachVidUrl,lyrics,notes,arranger,arrWebsite,arrangedYear,sungBy,sungWebsite,sungYear,quartet,quartetWebsite,teacher,teacherWebsite,provider,providerWebsite,posted,isClassic,collection,rating,ratingCount,downloaded,lastUpdated,sheetMusicUrl,sheetMusicType,notationUrl,notationType,allPartsUrl,bassUrl,bariUrl,leadUrl,tenorUrl,const DeepCollectionEquality().hash(_videos)]);

@override
String toString() {
  return 'BarbershopTag(id: $id, title: $title, altTitle: $altTitle, version: $version, keyMode: $keyMode, keyTonic: $keyTonic, parts: $parts, type: $type, recording: $recording, teachVidUrl: $teachVidUrl, lyrics: $lyrics, notes: $notes, arranger: $arranger, arrWebsite: $arrWebsite, arrangedYear: $arrangedYear, sungBy: $sungBy, sungWebsite: $sungWebsite, sungYear: $sungYear, quartet: $quartet, quartetWebsite: $quartetWebsite, teacher: $teacher, teacherWebsite: $teacherWebsite, provider: $provider, providerWebsite: $providerWebsite, posted: $posted, isClassic: $isClassic, collection: $collection, rating: $rating, ratingCount: $ratingCount, downloaded: $downloaded, lastUpdated: $lastUpdated, sheetMusicUrl: $sheetMusicUrl, sheetMusicType: $sheetMusicType, notationUrl: $notationUrl, notationType: $notationType, allPartsUrl: $allPartsUrl, bassUrl: $bassUrl, bariUrl: $bariUrl, leadUrl: $leadUrl, tenorUrl: $tenorUrl, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$BarbershopTagCopyWith<$Res> implements $BarbershopTagCopyWith<$Res> {
  factory _$BarbershopTagCopyWith(_BarbershopTag value, $Res Function(_BarbershopTag) _then) = __$BarbershopTagCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? altTitle, String? version, String? keyMode, String? keyTonic, int? parts, String? type, String? recording, String? teachVidUrl, String? lyrics, String? notes, String? arranger, String? arrWebsite, int? arrangedYear, String? sungBy, String? sungWebsite, int? sungYear, String? quartet, String? quartetWebsite, String? teacher, String? teacherWebsite, String? provider, String? providerWebsite, String? posted, bool isClassic, String? collection, double? rating, int? ratingCount, int? downloaded, String? lastUpdated, String? sheetMusicUrl, String? sheetMusicType, String? notationUrl, String? notationType, String? allPartsUrl, String? bassUrl, String? bariUrl, String? leadUrl, String? tenorUrl, List<BarbershopTagVideo> videos
});




}
/// @nodoc
class __$BarbershopTagCopyWithImpl<$Res>
    implements _$BarbershopTagCopyWith<$Res> {
  __$BarbershopTagCopyWithImpl(this._self, this._then);

  final _BarbershopTag _self;
  final $Res Function(_BarbershopTag) _then;

/// Create a copy of BarbershopTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? altTitle = freezed,Object? version = freezed,Object? keyMode = freezed,Object? keyTonic = freezed,Object? parts = freezed,Object? type = freezed,Object? recording = freezed,Object? teachVidUrl = freezed,Object? lyrics = freezed,Object? notes = freezed,Object? arranger = freezed,Object? arrWebsite = freezed,Object? arrangedYear = freezed,Object? sungBy = freezed,Object? sungWebsite = freezed,Object? sungYear = freezed,Object? quartet = freezed,Object? quartetWebsite = freezed,Object? teacher = freezed,Object? teacherWebsite = freezed,Object? provider = freezed,Object? providerWebsite = freezed,Object? posted = freezed,Object? isClassic = null,Object? collection = freezed,Object? rating = freezed,Object? ratingCount = freezed,Object? downloaded = freezed,Object? lastUpdated = freezed,Object? sheetMusicUrl = freezed,Object? sheetMusicType = freezed,Object? notationUrl = freezed,Object? notationType = freezed,Object? allPartsUrl = freezed,Object? bassUrl = freezed,Object? bariUrl = freezed,Object? leadUrl = freezed,Object? tenorUrl = freezed,Object? videos = null,}) {
  return _then(_BarbershopTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,altTitle: freezed == altTitle ? _self.altTitle : altTitle // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,keyMode: freezed == keyMode ? _self.keyMode : keyMode // ignore: cast_nullable_to_non_nullable
as String?,keyTonic: freezed == keyTonic ? _self.keyTonic : keyTonic // ignore: cast_nullable_to_non_nullable
as String?,parts: freezed == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,recording: freezed == recording ? _self.recording : recording // ignore: cast_nullable_to_non_nullable
as String?,teachVidUrl: freezed == teachVidUrl ? _self.teachVidUrl : teachVidUrl // ignore: cast_nullable_to_non_nullable
as String?,lyrics: freezed == lyrics ? _self.lyrics : lyrics // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,arranger: freezed == arranger ? _self.arranger : arranger // ignore: cast_nullable_to_non_nullable
as String?,arrWebsite: freezed == arrWebsite ? _self.arrWebsite : arrWebsite // ignore: cast_nullable_to_non_nullable
as String?,arrangedYear: freezed == arrangedYear ? _self.arrangedYear : arrangedYear // ignore: cast_nullable_to_non_nullable
as int?,sungBy: freezed == sungBy ? _self.sungBy : sungBy // ignore: cast_nullable_to_non_nullable
as String?,sungWebsite: freezed == sungWebsite ? _self.sungWebsite : sungWebsite // ignore: cast_nullable_to_non_nullable
as String?,sungYear: freezed == sungYear ? _self.sungYear : sungYear // ignore: cast_nullable_to_non_nullable
as int?,quartet: freezed == quartet ? _self.quartet : quartet // ignore: cast_nullable_to_non_nullable
as String?,quartetWebsite: freezed == quartetWebsite ? _self.quartetWebsite : quartetWebsite // ignore: cast_nullable_to_non_nullable
as String?,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as String?,teacherWebsite: freezed == teacherWebsite ? _self.teacherWebsite : teacherWebsite // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,providerWebsite: freezed == providerWebsite ? _self.providerWebsite : providerWebsite // ignore: cast_nullable_to_non_nullable
as String?,posted: freezed == posted ? _self.posted : posted // ignore: cast_nullable_to_non_nullable
as String?,isClassic: null == isClassic ? _self.isClassic : isClassic // ignore: cast_nullable_to_non_nullable
as bool,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: freezed == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int?,downloaded: freezed == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as int?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as String?,sheetMusicUrl: freezed == sheetMusicUrl ? _self.sheetMusicUrl : sheetMusicUrl // ignore: cast_nullable_to_non_nullable
as String?,sheetMusicType: freezed == sheetMusicType ? _self.sheetMusicType : sheetMusicType // ignore: cast_nullable_to_non_nullable
as String?,notationUrl: freezed == notationUrl ? _self.notationUrl : notationUrl // ignore: cast_nullable_to_non_nullable
as String?,notationType: freezed == notationType ? _self.notationType : notationType // ignore: cast_nullable_to_non_nullable
as String?,allPartsUrl: freezed == allPartsUrl ? _self.allPartsUrl : allPartsUrl // ignore: cast_nullable_to_non_nullable
as String?,bassUrl: freezed == bassUrl ? _self.bassUrl : bassUrl // ignore: cast_nullable_to_non_nullable
as String?,bariUrl: freezed == bariUrl ? _self.bariUrl : bariUrl // ignore: cast_nullable_to_non_nullable
as String?,leadUrl: freezed == leadUrl ? _self.leadUrl : leadUrl // ignore: cast_nullable_to_non_nullable
as String?,tenorUrl: freezed == tenorUrl ? _self.tenorUrl : tenorUrl // ignore: cast_nullable_to_non_nullable
as String?,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<BarbershopTagVideo>,
  ));
}


}

// dart format on
