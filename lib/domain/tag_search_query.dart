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
    bool? isClassic,
  }) = _TagSearchQuery;

  const TagSearchQuery._();

  factory TagSearchQuery.fromQueryParameters(Map<String, List<String>> params) {
    return TagSearchQuery(
      text: params['text']?.singleOrNull,
      voicings: params['voicings[]'],
      numParts: params['numParts[]']?.map(int.parse).toList(),
      sortOrder: TagSortOrder.values.firstWhere(
        (i) => i.name == params['sortOrder']?.single,
      ),
      limit: switch (params['limit']?.singleOrNull) {
        final String value => int.tryParse(value),
        _ => null,
      },
      isClassic: switch (params['isClassic']?.singleOrNull) {
        final String value => bool.tryParse(value),
        _ => null,
      },
    );
  }

  int? get exactId => switch (text) {
    null => null,
    final value => int.tryParse(value),
  };

  String asQueryParameters() {
    final params = <String>[
      if (text != null && text!.isNotEmpty) 'text=$text',
      for (final item in (voicings ?? [])) ...['voicings[]=$item'],
      for (final item in (numParts ?? [])) ...['numParts[]=$item'],
      'sortOrder=${sortOrder.name}',
      if (limit != null) 'limit=$limit',
      if (isClassic != null) 'isClassic=$isClassic',
    ];
    return params.join('&');
  }
}

enum TagSortOrder {
  titleAsc,
  dateDesc,
  downloadsDesc,
  ratingDesc,
  id,
}
