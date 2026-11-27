import 'dart:async';
import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagly/data/fold_repository.dart';
import 'package:tagly/domain/vertical_bar.dart';
import 'package:tagly/presentation/audio_player/learning_track_player.dart';
import 'package:tagly/presentation/collections/tag_collection_screen.dart';
import 'package:tagly/presentation/favorites/favorites_screen.dart';
import 'package:tagly/presentation/lists/view_list_screen.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/utils/list_detail_layout.dart';
import 'package:tagly/presentation/utils/tag_list_tile.dart';
import 'package:tagly/presentation/utils/vertical_bar_controls.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';

import '../helpers/fake_cache_manager.dart';
import '../helpers/fake_tags.dart';
import '../helpers/test_db.dart';
import '../helpers/test_providers.dart';

const _wide = Size(951, 669);
const _narrow = Size(466, 678);

void main() {
  group('list and tag split', () {
    late Database db;
    late List<SingleChildWidget> providers;
    late int listId;
    late StreamController<Object?> foldEvents;
    final tagId = fakeTag.id;

    setUp(() async {
      db = await openTestDb();
      await seedTestDb(db);
      await db.update(
        'tags',
        {'is_favorite': 1},
        where: 'id = ?',
        whereArgs: [tagId],
      );
      listId = await db.insert('lists', {'name': 'Mine'});
      await db.insert('list_tags', {'list_id': listId, 'tag_id': tagId});

      foldEvents = StreamController<Object?>.broadcast();
      addTearDown(foldEvents.close);

      final cacheManager = MockCacheManager();
      when(() => cacheManager.getSingleFile(any()))
          .thenAnswer((_) => Completer<File>().future);

      providers = await getTestProviders(
        db: db,
        overrides: [
          Provider<CacheManager>.value(value: cacheManager),
          Provider<SharePlus>.value(value: SharePlus.instance),
          ChangeNotifierProvider(
            create: (_) => FoldRepository(regionEvents: foldEvents.stream),
          ),
        ],
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<GoRouter> pumpApp(
      WidgetTester tester,
      Size size,
      String location, {
      VerticalBar? verticalBar,
    }) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late GoRouter router;
      await tester.pumpWidget(
        MultiProvider(
          providers: providers,
          child: Builder(
            builder: (context) {
              router = context.read();
              return MaterialApp.router(
                routerConfig: router,
                builder: (context, child) =>
                    VerticalBarScope(verticalBar: verticalBar, child: child!),
              );
            },
          ),
        ),
      );
      router.go(location);
      await _settle(tester);
      return router;
    }

    testWidgets('shows the list beside the selected tag when wide', (
      tester,
    ) async {
      await pumpApp(tester, _wide, '/favorites/tags/$tagId');

      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(
        tester.widget<TagListTile>(find.byType(TagListTile)).selected,
        true,
      );
    });

    testWidgets('hides the tag back button only beside the list', (
      tester,
    ) async {
      await pumpApp(tester, _wide, '/favorites/tags/$tagId');
      Finder tagBackButton() => find.descendant(
        of: find.byType(ViewTagScreen),
        matching: find.byType(BackButton),
      );
      expect(tagBackButton(), findsNothing);

      tester.view.physicalSize = _narrow;
      await _settle(tester);
      expect(tagBackButton(), findsOneWidget);
    });

    testWidgets('puts the back button and tag controls in the vertical bar', (
      tester,
    ) async {
      await pumpApp(
        tester,
        _wide,
        '/favorites/tags/$tagId',
        verticalBar: const VerticalBar(
          edge: VerticalBarEdge.right,
          controls: ScreenRect(left: 879, top: 124, width: 48, height: 511),
        ),
      );

      // The list's back button leads the column; the tag's controls follow.
      final back = find.byType(BackButton);
      expect(back, findsOneWidget);
      expect(tester.getCenter(back).dx, 903);
      expect(tester.getTopLeft(back).dy, 124);
      for (final icon in [Icons.favorite_rounded, Icons.more_vert_rounded]) {
        expect(tester.getCenter(find.byIcon(icon)).dx, 903);
        expect(
          tester.getTopLeft(find.byIcon(icon)).dy,
          greaterThanOrEqualTo(tester.getBottomLeft(back).dy),
        );
      }
      final listBar = find.descendant(
        of: find.byType(FavoritesScreen),
        matching: find.byType(AppBar),
      );
      expect(listBar, findsOneWidget);
      expect(
        find.descendant(of: listBar, matching: find.byType(BackButton)),
        findsNothing,
      );
    });

    testWidgets('shows a placeholder beside the list when nothing is chosen', (
      tester,
    ) async {
      await pumpApp(tester, _wide, '/favorites');

      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.byType(NoTagSelected), findsOneWidget);
    });

    testWidgets('shows only the tag when narrow', (tester) async {
      await pumpApp(tester, _narrow, '/favorites/tags/$tagId');

      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(find.byType(FavoritesScreen), findsNothing);
    });

    testWidgets('shows only the tag in a wide but upright window', (
      tester,
    ) async {
      await pumpApp(tester, const Size(669, 951), '/favorites/tags/$tagId');

      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(find.byType(FavoritesScreen), findsNothing);
    });

    testWidgets('shows only the tag on the outer display in landscape', (
      tester,
    ) async {
      await pumpApp(tester, const Size(678, 466), '/favorites/tags/$tagId');

      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(find.byType(FavoritesScreen), findsNothing);
    });

    testWidgets('keeps the open tag when the window narrows and widens', (
      tester,
    ) async {
      final router = await pumpApp(tester, _wide, '/favorites/tags/$tagId');
      final wideState = tester.state(find.byType(ViewTagScreen));

      tester.view.physicalSize = _narrow;
      await _settle(tester);
      expect(tester.state(find.byType(ViewTagScreen)), same(wideState));
      expect(find.byType(FavoritesScreen), findsNothing);

      tester.view.physicalSize = _wide;
      await _settle(tester);
      expect(tester.state(find.byType(ViewTagScreen)), same(wideState));
      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(router.state.uri.path, '/favorites/tags/$tagId');
    });

    testWidgets('opens a tag from the list when narrow', (tester) async {
      final router = await pumpApp(tester, _narrow, '/favorites');

      await tester.tap(find.byType(TagListTile));
      await _settle(tester);

      expect(router.state.uri.path, '/favorites/tags/$tagId');
      expect(find.byType(ViewTagScreen), findsOneWidget);
    });

    testWidgets('goes home from the list when narrow', (tester) async {
      final router = await pumpApp(tester, _narrow, '/favorites');

      await tester.tap(find.byType(BackButton));
      await _settle(tester);

      expect(router.state.uri.path, '/');
      expect(find.byType(SearchScreen), findsOneWidget);
    });

    testWidgets('updates the list when the tag pane removes a favorite', (
      tester,
    ) async {
      await pumpApp(tester, _wide, '/favorites/tags/$tagId');

      await tester.tap(
        find.descendant(
          of: find.byType(ViewTagScreen),
          matching: find.byIcon(Icons.favorite_rounded),
        ),
      );
      await _settle(tester);

      expect(find.byType(TagListTile), findsNothing);
    });

    testWidgets('keeps the list scroll position when the window narrows', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const Size(951, 300),
        '/collection?title=All&sortOrder=id',
      );
      await tester.drag(find.byType(TagListTile).first, const Offset(0, -150));
      await _settle(tester);
      final before = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels;
      expect(before, greaterThan(0));

      tester.view.physicalSize = const Size(466, 300);
      await _settle(tester);

      final after = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels;
      expect(after, before);
    });

    testWidgets('moves the player below a tabletop fold and keeps it', (
      tester,
    ) async {
      await tester.runAsync(
        () => db.update(
          'tags',
          {'all_parts_url': 'https://example.com/all.mp3'},
          where: 'id = ?',
          whereArgs: [tagId],
        ),
      );
      const portrait = Size(669, 951);
      await pumpApp(tester, portrait, '/favorites/tags/$tagId');
      final player = find.byType(LearningTrackPlayer);
      final playerState = tester.state(player);
      expect(tester.getBottomLeft(player).dy, greaterThan(900));

      foldEvents.add([
        {'left': 0, 'top': 455, 'width': 669, 'height': 40, 'active': true},
      ]);
      await _settle(tester);
      expect(tester.state(player), same(playerState));
      expect(tester.getTopLeft(player).dy, greaterThan(495));
      expect(tester.getBottomLeft(player).dy, lessThan(900));

      foldEvents.add([
        {'left': 0, 'top': 455, 'width': 669, 'height': 40, 'active': false},
      ]);
      await _settle(tester);
      expect(tester.state(player), same(playerState));
      expect(tester.getBottomLeft(player).dy, greaterThan(900));
    });

    testWidgets('keeps collection filters in the tag URL', (tester) async {
      final router = await pumpApp(
        tester,
        _wide,
        '/collection?title=Popular&sortOrder=downloadsDesc',
      );

      await tester.tap(find.byType(TagListTile).first);
      await _settle(tester);

      expect(router.state.uri.path, startsWith('/collection/tags/'));
      expect(router.state.uri.queryParameters, {
        'title': 'Popular',
        'sortOrder': 'downloadsDesc',
      });
      expect(find.byType(TagCollectionScreen), findsOneWidget);
      expect(find.byType(ViewTagScreen), findsOneWidget);
    });

    Future<void> searchAndOpenResult(WidgetTester tester) async {
      await tester.tap(find.byType(SearchBar));
      await _settle(tester);
      await tester.enterText(find.byType(TextField).last, '$tagId');
      await _settle(tester);
      await tester.tap(find.byType(TagListTile).last);
      await _settle(tester);
    }

    testWidgets('opens a search result beside the results when wide', (
      tester,
    ) async {
      final router = await pumpApp(tester, _wide, '/');

      await searchAndOpenResult(tester);

      expect(router.state.uri.path, '/collection/tags/$tagId');
      expect(router.state.uri.queryParameters['text'], '$tagId');
      expect(router.state.uri.queryParameters['title'], '“$tagId”');
      expect(find.byType(TagCollectionScreen), findsOneWidget);
      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(
        tester.widget<TagListTile>(find.byType(TagListTile)).selected,
        true,
      );
    });

    testWidgets('opens a search result over the results when narrow', (
      tester,
    ) async {
      final router = await pumpApp(tester, _narrow, '/');

      await searchAndOpenResult(tester);

      expect(router.state.uri.toString(), '/tag?id=$tagId');
      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(find.byType(TagCollectionScreen), findsNothing);
    });

    testWidgets('opens the tag menu clear of the vertical bar when folded', (
      tester,
    ) async {
      tester.view
        ..padding = const FakeViewPadding(right: 84)
        ..displayFeatures = [
          const DisplayFeature(
            bounds: Rect.fromLTRB(455.5, 0, 495.5, 669),
            type: DisplayFeatureType.fold,
            state: DisplayFeatureState.postureHalfOpened,
          ),
        ];
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetDisplayFeatures);
      await pumpApp(
        tester,
        _wide,
        '/favorites/tags/$tagId',
        verticalBar: const VerticalBar(
          edge: VerticalBarEdge.right,
          controls: ScreenRect(left: 879, top: 124, width: 48, height: 511),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await _settle(tester);

      final menu = tester.getRect(
        find.ancestor(
          of: find.text('Tag Details'),
          matching: find.byType(MenuItemButton),
        ),
      );
      expect(menu.left, greaterThanOrEqualTo(495.5));
      expect(menu.right, lessThanOrEqualTo(_wide.width - 84));
    });

    testWidgets('opens a sheet from the tag pane on its page of the fold', (
      tester,
    ) async {
      tester.view.displayFeatures = [
        const DisplayFeature(
          bounds: Rect.fromLTRB(455.5, 0, 495.5, 669),
          type: DisplayFeatureType.fold,
          state: DisplayFeatureState.postureHalfOpened,
        ),
      ];
      addTearDown(tester.view.resetDisplayFeatures);
      await pumpApp(tester, _wide, '/favorites/tags/$tagId');

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await _settle(tester);
      await tester.tap(find.text('Share'));
      await _settle(tester);
      await tester.tap(find.text('What do I choose?'));
      await _settle(tester);

      final sheet = tester.getRect(find.byType(BottomSheet));
      expect(sheet.left, greaterThanOrEqualTo(495.5));
      expect(sheet.width, greaterThan(300));
    });

    testWidgets('moves the search view buttons into the vertical bar', (
      tester,
    ) async {
      // The closed display held upright: the column sits below the camera
      // and status bar.
      const column = ScreenRect(left: 394, top: 172, width: 48, height: 450);
      await pumpApp(
        tester,
        _narrow,
        '/',
        verticalBar: const VerticalBar(
          edge: VerticalBarEdge.right,
          controls: column,
        ),
      );

      await tester.tap(find.byType(SearchBar));
      await _settle(tester);

      final filter = find.byIcon(Icons.filter_list_rounded);
      final help = find.byIcon(Icons.help_outline_rounded);
      expect(filter, findsOneWidget);
      expect(help, findsOneWidget);
      for (final control in [filter, help]) {
        expect(tester.getCenter(control).dx, 418);
        expect(tester.getTopLeft(control).dy, greaterThan(column.top));
      }

      await tester.tap(find.byType(BackButton));
      await _settle(tester);
      expect(filter, findsNothing);
    });

    testWidgets('shows a list beside its tag when wide', (tester) async {
      await pumpApp(tester, _wide, '/lists/$listId/tags/$tagId?name=Mine');

      expect(find.byType(ViewListScreen), findsOneWidget);
      expect(find.byType(ViewTagScreen), findsOneWidget);
      expect(find.text('Mine'), findsOneWidget);
    });
  });
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}
