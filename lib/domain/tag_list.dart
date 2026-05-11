import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_list.freezed.dart';
part 'tag_list.g.dart';

@freezed
abstract class TagList with _$TagList {
  const factory TagList({
    required int id,
    required String name,
  }) = _TagList;

  factory TagList.fromJson(Map<String, dynamic> json) =>
      _$TagListFromJson(json);
}
