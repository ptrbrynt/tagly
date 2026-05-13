import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/data/tags_xml_parser.dart';

import '../helpers/fake_tags.dart';

void main() {
  group('tags xml parser', () {
    group('envelope attributes', () {
      test('returns empty tag list when no <tag> elements present', () {
        const xml = '''
<tags available="100" count="0" stamp="2026-01-01 00:00:00">
</tags>''';
        final result = TagsXmlParser.parse(xml);
        expect(result.available, 100);
        expect(result.tags, isEmpty);
      });

      test('defaults available and count to 0 when attributes are absent', () {
        const xml = '<tags stamp=""><tag><id>1</id><Title>T</Title></tag></tags>';
        final result = TagsXmlParser.parse(xml);
        expect(result.available, 0);
        expect(result.count, 0);
      });
    });

    group('isClassic', () {
      test('is true when Classic element has content', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag>
    <id>1</id><Title>T</Title>
    <Classic>yes</Classic>
  </tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.isClassic, isTrue);
      });

      test('is false when Classic element is absent', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.isClassic, isFalse);
      });
    });

    group('sheet music URL fallback', () {
      test('prefers SheetMusicAlt over SheetMusic', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag>
    <id>1</id><Title>T</Title>
    <SheetMusic type="pdf">http://redirect.example.com</SheetMusic>
    <SheetMusicAlt>http://static.example.com/file.pdf</SheetMusicAlt>
  </tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.sheetMusicUrl, 'http://static.example.com/file.pdf');
      });

      test('falls back to SheetMusic when SheetMusicAlt is absent', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag>
    <id>1</id><Title>T</Title>
    <SheetMusic type="pdf">http://redirect.example.com</SheetMusic>
  </tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.sheetMusicUrl, 'http://redirect.example.com');
        expect(tag.sheetMusicType, 'pdf');
      });

      test('sheetMusicUrl is null when neither element is present', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.sheetMusicUrl, isNull);
        expect(tag.sheetMusicType, isNull);
      });
    });

    group('date parsing', () {
      test('parses standard API date format', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title><Posted>Tue, 25 Jan 2011</Posted></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.posted, '2011-01-25');
      });

      test('returns null for malformed date', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title><Posted>not a date</Posted></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.posted, isNull);
      });

      test('returns null when Posted element is absent', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.posted, isNull);
      });
    });

    group('key splitting', () {
      test('splits Major:C into mode and tonic', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title><WritKey>Major:C</WritKey></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.keyMode, 'Major');
        expect(tag.keyTonic, 'C');
      });

      test('key without colon yields mode only, tonic null', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title><WritKey>Major</WritKey></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.keyMode, 'Major');
        expect(tag.keyTonic, isNull);
      });

      test('absent WritKey yields null mode and tonic', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag><id>1</id><Title>T</Title></tag>
</tags>''';
        final tag = TagsXmlParser.parse(xml).tags.first;
        expect(tag.keyMode, isNull);
        expect(tag.keyTonic, isNull);
      });
    });

    group('video parsing', () {
      test('isMultitrack is true when Multitrack element is "yes"', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag>
    <id>1</id><Title>T</Title>
    <videos>
      <video>
        <id>10</id>
        <Multitrack>Yes</Multitrack>
      </video>
    </videos>
  </tag>
</tags>''';
        final video = TagsXmlParser.parse(xml).tags.first.videos.first;
        expect(video.isMultitrack, isTrue);
      });

      test('isMultitrack is false when Multitrack element is absent', () {
        const xml = '''
<tags available="1" count="1" stamp="">
  <tag>
    <id>1</id><Title>T</Title>
    <videos><video><id>10</id></video></videos>
  </tag>
</tags>''';
        final video = TagsXmlParser.parse(xml).tags.first.videos.first;
        expect(video.isMultitrack, isFalse);
      });
    });

    test('parses tags successfully', () {
      const input = fakeTagsXml;
      final result = TagsXmlParser.parse(input);

      expect(result.available, 6910);
      expect(result.count, 10);
      expect(result.stamp, '2026-05-01 08:39:20');

      expect(result.tags, hasLength(10));

      // First tag — verifies basic fields, key splitting, date parsing,
      // HTML entity decoding, and SheetMusicAlt preference.
      final tag1 = result.tags[0];
      expect(tag1.id, 1482);
      expect(tag1.title, "'Less You Listen");
      expect(tag1.altTitle, 'For a Heart Is Nothing');
      expect(tag1.version, 'C to F Version');
      expect(tag1.keyMode, 'Major');
      expect(tag1.keyTonic, 'C');
      expect(tag1.parts, 4);
      expect(tag1.type, 'Barbershop');
      expect(tag1.recording, 'single part only');
      expect(tag1.teachVidUrl, isNull);
      expect(tag1.lyrics, "For a heart is nothing, 'less you listen");
      expect(tag1.arranger, 'Paul Paddock');
      expect(tag1.arrWebsite, isNull);
      expect(tag1.arrangedYear, 2011);
      expect(tag1.sungBy, isNull);
      expect(tag1.quartet, 'Pdpaddoc');
      expect(tag1.posted, '2011-01-25');
      expect(tag1.isClassic, false);
      expect(tag1.rating, 3.2024);
      expect(tag1.ratingCount, 662);
      expect(tag1.downloaded, 19124);
      expect(tag1.lastUpdated, '2026-04-30 07:11:52');
      // Prefers the static SheetMusicAlt URL over the redirect URL.
      expect(tag1.sheetMusicUrl,
          'https://www.barbershoptags.com/tags/_Less_You_Listen.png');
      expect(tag1.sheetMusicType, 'png');
      expect(tag1.notationUrl, isNull);
      expect(tag1.notationType, isNull);
      expect(
        tag1.allPartsUrl,
        'https://www.barbershoptags.com/dbaction.php?action=DownloadFile&dbase=tags&id=1482&fldname=AllParts',
      );
      expect(
        tag1.bassUrl,
        'https://www.barbershoptags.com/dbaction.php?action=DownloadFile&dbase=tags&id=1482&fldname=Bass',
      );
      expect(tag1.videos, isEmpty);

      // Tag 4 — has a NotationAlt, no audio parts.
      final tag4 = result.tags[3];
      expect(tag4.id, 3687);
      expect(tag4.notationUrl,
          'https://www.barbershoptags.com/tags/_Til_Him.musx');
      expect(tag4.notationType, 'musx');
      expect(tag4.allPartsUrl, isNull);
      expect(tag4.bassUrl, isNull);

      // Tag 5 — has one video; verifies video parsing.
      final tag5 = result.tags[4];
      expect(tag5.id, 4696);
      expect(tag5.videos, hasLength(1));
      final video5 = tag5.videos.first;
      expect(video5.id, 1547);
      expect(video5.tagId, 4696);
      expect(video5.description, isNull);
      expect(video5.sungKeyMode, 'Major');
      expect(video5.sungKeyTonic, 'F');
      expect(video5.isMultitrack, false);
      expect(video5.youtubeCode, '5yMeEGbca4U');
      expect(video5.facebookUrl, isNull);
      expect(video5.sungBy, 'Ravon S');
      expect(video5.posted, '2020-03-30');

      // Tag 10 — video with a Facebook URL and no YouTube code.
      final tag10 = result.tags[9];
      expect(tag10.id, 4952);
      expect(tag10.allPartsUrl, isNull);
      expect(tag10.videos, hasLength(1));
      final video10 = tag10.videos.first;
      expect(video10.id, 1652);
      expect(video10.youtubeCode, isNull);
      expect(video10.facebookUrl,
          'https://www.facebook.com/100004369746986/videos/1607779236044386/?extid=ymDkDyWmCH0gpXNa');
      expect(video10.sungBy, 'Nick Nack Paddy Catt');
      expect(video10.posted, '2020-09-28');
    });
  });
}
