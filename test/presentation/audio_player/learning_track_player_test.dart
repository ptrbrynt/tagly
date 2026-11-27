import 'dart:async';

import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tagly/presentation/audio_player/audio_player_widget.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';

import '../../helpers/fake_cache_manager.dart';

void main() {
  group('learning track player', () {
    late MockCacheManager cacheManager;

    setUp(() {
      cacheManager = MockCacheManager();
      when(() => cacheManager.getSingleFile(any()))
          .thenAnswer((_) => Completer<File>().future);
    });

    Future<void> pumpPlayer(WidgetTester tester, Size size) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LearningTrackPlayer(
              tracks: const {'All parts': 'https://example.com/all.mp3'},
              cacheManager: cacheManager,
            ),
          ),
        ),
      );
    }

    testWidgets('keeps the audio player alive when the layout changes', (
      tester,
    ) async {
      await pumpPlayer(tester, const Size(400, 800));
      final portraitState = tester.state(find.byType(AudioPlayerWidget));

      await pumpPlayer(tester, const Size(800, 400));
      final landscapeState = tester.state(find.byType(AudioPlayerWidget));

      expect(landscapeState, same(portraitState));
    });

    testWidgets('stacks the track picker above the player when narrow', (
      tester,
    ) async {
      await pumpPlayer(tester, const Size(400, 800));

      expect(find.byType(VerticalDivider), findsNothing);
    });

    testWidgets('lays out the picker beside the player when wide', (
      tester,
    ) async {
      await pumpPlayer(tester, const Size(800, 400));

      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    testWidgets('keeps to one row in a short, narrow window', (tester) async {
      // The outer display in landscape, less the vertical bar.
      await pumpPlayer(tester, const Size(560, 466));

      expect(find.byType(VerticalDivider), findsOneWidget);
      expect(
        tester.getCenter(find.byType(DropdownButton<String>)).dy,
        moreOrLessEquals(tester.getCenter(find.byType(AudioPlayerWidget)).dy),
      );
    });
  });
}
