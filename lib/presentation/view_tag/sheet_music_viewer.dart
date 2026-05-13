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
  bool _hasError = false;

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
    if (mounted) {
      setState(() {
        _filePath = null;
        _hasError = false;
      });
    }
    try {
      final file = await widget.cacheManager.getSingleFile(widget.url);
      if (mounted) setState(() => _filePath = file.path);
    } on Exception {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _SheetMusicError(onRetry: _load);
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

class _SheetMusicError extends StatelessWidget {
  const _SheetMusicError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      padding: const .all(24),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Sheet music unavailable — check your connection and try again.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            label: const Text('Retry'),
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
    );
  }
}
