import 'package:flutter_test/flutter_test.dart';
import 'package:tagly/domain/barbershop_tag.dart';

void main() {
  group('BarbershopTag model', () {
    test('formats tag URI correctly', () {
      const tag = BarbershopTag(
        id: 36,
        title: 'Last Night was the End of the World',
      );

      expect(
        tag.tagUri,
        equals(
          Uri.parse(
            'https://www.barbershoptags.com/tag-36-Last-Night-was-the-End-of-the-World',
          ),
        ),
      );
    });

    test('formats tag URI correctly with version', () {
      const tag = BarbershopTag(
        id: 1809,
        title: 'Lost',
        version: '52Eighty Version',
      );

      expect(
        tag.tagUri,
        equals(
          Uri.parse(
            'https://www.barbershoptags.com/tag-1809-Lost-(52Eighty-Version)',
          ),
        ),
      );
    });
  });
}
