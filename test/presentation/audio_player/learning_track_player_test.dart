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
      when(
        () => cacheManager.getSingleFile(any()),
      ).thenAnswer((_) => Completer<File>().future);
    });

    Widget app(Size size) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: Scaffold(
            body: LearningTrackPlayer(
              tracks: const {'All parts': 'https://example.com/all.mp3'},
              cacheManager: cacheManager,
            ),
          ),
        ),
      );
    }

    testWidgets('keeps the audio player alive when orientation changes', (
      tester,
    ) async {
      await tester.pumpWidget(app(const Size(400, 800)));
      final portraitState = tester.state(find.byType(AudioPlayerWidget));

      await tester.pumpWidget(app(const Size(800, 400)));
      final landscapeState = tester.state(find.byType(AudioPlayerWidget));

      expect(landscapeState, same(portraitState));
    });
  });
}
