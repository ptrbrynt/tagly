import 'package:tagly/domain/barbershop_tag.dart';
import 'package:tagly/domain/barbershop_tag_video.dart';
import 'package:xml/xml.dart';

/// Parsed representation of the top-level [<tags>] response envelope.
class TagsResponse {
  const TagsResponse({
    required this.available,
    required this.count,
    required this.stamp,
    required this.tags,
  });

  /// Total number of tags available on the server (across all pages).
  final int available;

  /// Number of tags included in this particular response.
  final int count;

  /// Server-side timestamp for this response.
  final String stamp;

  final List<BarbershopTag> tags;
}

/// Parses the barbershoptags.com XML API response into [TagsResponse].
abstract final class TagsXmlParser {
  TagsXmlParser._();

  /// Parse a raw XML [source] string into a [TagsResponse].
  static TagsResponse parse(String source) {
    final root = XmlDocument.parse(source).rootElement; // <tags>

    return TagsResponse(
      available: int.parse(root.getAttribute('available') ?? '0'),
      count: int.parse(root.getAttribute('count') ?? '0'),
      stamp: root.getAttribute('stamp') ?? '',
      tags: root.findElements('tag').map(_parseTag).toList(),
    );
  }

  // ----------------------------------------------------------------
  // Tag
  // ----------------------------------------------------------------

  static BarbershopTag _parseTag(XmlElement el) {
    final (keyMode, keyTonic) = _splitKey(_text(el, 'WritKey'));

    final videosEl = el.getElement('videos');
    final tagId = _int(el, 'id')!;
    final videos =
        videosEl
            ?.findElements('video')
            .map((v) => _parseVideo(v, tagId))
            .toList() ??
        const [];

    return BarbershopTag(
      id: tagId,
      title: _text(el, 'Title') ?? '',
      altTitle: _text(el, 'AltTitle'),
      version: _text(el, 'Version'),
      keyMode: keyMode,
      keyTonic: keyTonic,
      parts: _int(el, 'Parts'),
      type: _text(el, 'Type'),
      recording: _text(el, 'Recording'),
      teachVidUrl: _text(el, 'TeachVid'),
      lyrics: _text(el, 'Lyrics'),
      notes: _text(el, 'Notes'),
      arranger: _text(el, 'Arranger'),
      arrWebsite: _text(el, 'ArrWebsite'),
      arrangedYear: _int(el, 'Arranged'),
      sungBy: _text(el, 'SungBy'),
      sungWebsite: _text(el, 'SungWebsite'),
      sungYear: _int(el, 'SungYear'),
      quartet: _text(el, 'Quartet'),
      quartetWebsite: _text(el, 'QWebsite'),
      teacher: _text(el, 'Teacher'),
      teacherWebsite: _text(el, 'TWebsite'),
      provider: _text(el, 'Provider'),
      providerWebsite: _text(el, 'ProvWebsite'),
      posted: _parseDate(_text(el, 'Posted')),
      // Classic element is empty when false, non-empty when true.
      isClassic: _text(el, 'Classic') != null,
      collection: _text(el, 'Collection'),
      rating: _double(el, 'Rating'),
      ratingCount: _int(el, 'RatingCount'),
      downloaded: _int(el, 'Downloaded'),
      lastUpdated: _text(el, 'stamp'),
      // Prefer the direct Alt URL (static file) over the download-
      // redirect URL — the static URL is better for offline caching.
      sheetMusicUrl: _text(el, 'SheetMusicAlt') ?? _text(el, 'SheetMusic'),
      sheetMusicType: el.getElement('SheetMusic')?.getAttribute('type'),
      notationUrl: _text(el, 'NotationAlt') ?? _text(el, 'Notation'),
      notationType: el.getElement('Notation')?.getAttribute('type'),
      allPartsUrl: _text(el, 'AllParts'),
      bassUrl: _text(el, 'Bass'),
      bariUrl: _text(el, 'Bari'),
      leadUrl: _text(el, 'Lead'),
      tenorUrl: _text(el, 'Tenor'),
      videos: videos,
    );
  }

  // ----------------------------------------------------------------
  // Video
  // ----------------------------------------------------------------

  static BarbershopTagVideo _parseVideo(XmlElement el, int tagId) {
    final (sungKeyMode, sungKeyTonic) = _splitKey(_text(el, 'SungKey'));

    return BarbershopTagVideo(
      id: _int(el, 'id')!,
      tagId: tagId,
      description: _text(el, 'Desc'),
      sungKeyMode: sungKeyMode,
      sungKeyTonic: sungKeyTonic,
      isMultitrack: _text(el, 'Multitrack')?.toLowerCase() == 'yes',
      youtubeCode: _text(el, 'Code'),
      facebookUrl: _text(el, 'Facebook'),
      sungBy: _text(el, 'SungBy'),
      sungWebsite: _text(el, 'SungWebsite'),
      posted: _parseDate(_text(el, 'Posted')),
    );
  }

  // ----------------------------------------------------------------
  // Element helpers
  // ----------------------------------------------------------------

  /// Returns the trimmed inner text of the first child element named
  /// [tag], or null if the element is absent or empty.
  static String? _text(XmlElement parent, String tag) {
    final text = parent.getElement(tag)?.innerText.trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  static int? _int(XmlElement parent, String tag) =>
      int.tryParse(_text(parent, tag) ?? '');

  static double? _double(XmlElement parent, String tag) =>
      double.tryParse(_text(parent, tag) ?? '');

  // ----------------------------------------------------------------
  // Domain helpers
  // ----------------------------------------------------------------

  /// Splits a key string like `"Major:C"` into a `(mode, tonic)` record.
  /// Returns `(null, null)` for null or malformed input.
  ///
  /// Requires Dart ≥ 3.0 for record syntax.
  static (String?, String?) _splitKey(String? raw) {
    if (raw == null) return (null, null);
    final idx = raw.indexOf(':');
    if (idx == -1) return (raw, null);
    return (raw.substring(0, idx), raw.substring(idx + 1));
  }

  /// Converts the API date format `"Tue, 25 Jan 2011"` to ISO 8601
  /// `"2011-01-25"`. Returns null for null or unparseable input.
  ///
  /// Avoids an `intl` dependency by parsing the fixed-structure
  /// format directly.
  static String? _parseDate(String? raw) {
    if (raw == null) return null;
    // Drop the weekday prefix ("Tue, ") and split the remainder.
    final comma = raw.indexOf(',');
    if (comma == -1) return null;
    final parts = raw.substring(comma + 2).trim().split(' ');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = _monthIndex[parts[1]];
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return '$year-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  static const _monthIndex = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };
}
