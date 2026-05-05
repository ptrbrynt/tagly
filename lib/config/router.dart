import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tagly/presentation/search/search_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_screen.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

GoRouter get router => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => SearchScreen(repository: context.watch()),
      routes: [
        GoRoute(
          path: 'tag',
          builder: (context, state) {
            final tagId = state.uri.queryParameters['id']!;
            return ViewTagScreen(
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
);
