import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tagly/presentation/audio_player/audio_player_widget.dart';

class LearningTrackPlayer extends StatefulWidget {
  const new({required this.tracks, required this.cacheManager, super.key});

  final Map<String, String> tracks;
  final CacheManager cacheManager;

  @override
  State<LearningTrackPlayer> createState() => _LearningTrackPlayerState();
}

class _LearningTrackPlayerState extends State<LearningTrackPlayer> {
  late String _selectedTrack;

  @override
  void initState() {
    super.initState();
    _selectedTrack = widget.tracks.keys.first;
  }

  @override
  void didUpdateWidget(LearningTrackPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mapEquals(widget.tracks, oldWidget.tracks)) {
      setState(() {
        _selectedTrack = widget.tracks.keys.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Align(alignment: .topLeft, child: _trackPicker()),
              const SizedBox(height: 8),
              _audioPlayer(),
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            children: [
              _trackPicker(),
              const VerticalDivider(width: 40),
              Expanded(child: _audioPlayer()),
            ],
          ),
        );
      },
    );
  }

  Widget _audioPlayer() {
    return AudioPlayerWidget(
      url: widget.tracks[_selectedTrack]!,
      cacheManager: widget.cacheManager,
    );
  }

  Widget _trackPicker() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        value: _selectedTrack,
        items: [
          for (final track in widget.tracks.keys)
            DropdownMenuItem(value: track, child: Text(track)),
        ],
        onChanged: (value) {
          setState(() {
            _selectedTrack = value!;
          });
        },
      ),
    );
  }
}
