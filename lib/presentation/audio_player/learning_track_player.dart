import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tagly/presentation/audio_player/audio_player_widget.dart';

class LearningTrackPlayer extends StatefulWidget {
  const LearningTrackPlayer({
    required this.tracks,
    required this.cacheManager,
    super.key,
  });

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
    if (widget.tracks != oldWidget.tracks) {
      setState(() {
        _selectedTrack = widget.tracks.keys.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        DropdownButtonHideUnderline(
          child: Align(
            alignment: .topStart,
            child: DropdownButton(
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
          ),
        ),
        const SizedBox(height: 8),
        AudioPlayerWidget(
          url: widget.tracks[_selectedTrack]!,
          cacheManager: widget.cacheManager,
        ),
      ],
    );
  }
}
