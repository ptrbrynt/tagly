import 'dart:async';
import 'dart:io' as io;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  String? _filePath;

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
    final file = await widget.cacheManager.getSingleFile(widget.url);

    if (mounted) {
      setState(() {
        _filePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_filePath) {
      null => const Center(child: CircularProgressIndicator.adaptive()),
      final path when path.endsWith('pdf') => PDFView(filePath: path),
      final path => ExtendedImage.file(
        io.File(path),
        mode: .gesture,
        fit: .contain,
      ),
    };
  }
}
