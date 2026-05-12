import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_search_query.freezed.dart';

@freezed
abstract class TagSearchQuery with _$TagSearchQuery {
  const factory TagSearchQuery({
    String? text,
    List<String>? voicings,
    List<int>? numParts,
    @Default(TagSortOrder.downloadsDesc) TagSortOrder sortOrder,
    int? limit,
  }) = _TagSearchQuery;

  const TagSearchQuery._();

  int? get exactId => switch (text) {
    null => null,
    final value => int.tryParse(value),
  };
}

enum TagSortOrder {
  titleAsc,
  dateDesc,
  downloadsDesc,
  ratingDesc,
}
