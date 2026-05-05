import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/tag_details/tag_details_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

GoRouter getRouter(List<NavigatorObserver> observers) => GoRouter(
  observers: observers,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) {
        return SearchScreen(
          repository: context.watch(),
          nearby: context.watch(),
        );
      },
      routes: [
        GoRoute(
          path: 'tag',
          builder: (context, state) {
            final tagId = state.uri.queryParameters['id']!;
            return ViewTagScreen(
              nearby: context.read(),
              cacheManager: context.read(),
              viewModel: ViewTagViewModel(
                repository: context.read(),
                tagId: int.parse(tagId),
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) {
                final tagId = state.uri.queryParameters['id']!;
                return TagDetailsScreen(
                  nearby: context.watch(),
                  viewModel: ViewTagViewModel(
                    repository: context.watch(),
                    tagId: int.parse(tagId),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
