import 'package:flutter/material.dart';
import 'package:tagly/domain/result.dart';
import 'package:tagly/presentation/view_tag/sheet_music_viewer.dart';
import 'package:tagly/presentation/view_tag/view_tag_view_model.dart';

class ViewTagScreen extends StatelessWidget {
  const ViewTagScreen({super.key, required this.viewModel});

  final ViewTagViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(),
          body: switch (viewModel.result) {
            null => Center(child: CircularProgressIndicator.adaptive()),
            Failure(:final message) => Center(child: Text(message)),
            Ok(:final value) => switch (value.sheetMusicUrl) {
              null => SizedBox.shrink(),
              final url => SheetMusicViewer(url: url),
            },
          },
        );
      },
    );
  }
}
