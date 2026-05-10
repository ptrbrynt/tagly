import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SheetMusicViewer extends StatefulWidget {
  const SheetMusicViewer({
    required this.url,
    required this.cacheManager,
    super.key,
  });

  final String url;
  final CacheManager cacheManager;

  @override
  State<SheetMusicViewer> createState() => _SheetMusicViewerState();
}

class _SheetMusicViewerState extends State<SheetMusicViewer> {
  final controller = WebViewController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(SheetMusicViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    final file = await widget.cacheManager.getSingleFile(widget.url);
    await controller.loadFile(file.path);
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : WebViewWidget(controller: controller);
  }
}
