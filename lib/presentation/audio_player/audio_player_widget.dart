import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    required this.url,
    required this.cacheManager,
    super.key,
  });

  final CacheManager cacheManager;
  final String url;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();
  StreamSubscription<ProcessingState>? _completionSubscription;

  /// Used to store the playback status of the player before seeking starts,
  /// so we can restart playback if necessary
  bool _shouldContinue = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription =
        _player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        await _player.seek(Duration.zero);
        await _player.pause();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    await _player.stop();
    final file = await widget.cacheManager.getSingleFile(widget.url);
    await _player.setAudioSource(AudioSource.file(file.path));
  }

  @override
  void dispose() {
    unawaited(_completionSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _playPauseButton(),
        Expanded(child: _progressSlider()),
      ],
    );
  }

  Widget _playPauseButton() {
    return StreamBuilder(
      stream: StreamGroup.merge([
        _player.playingStream,
        _player.playerStateStream,
        _player.processingStateStream,
      ]),
      builder: (context, _) {
        return IconButton(
          onPressed: _player.processingState == .ready
              ? () async {
                  await (_player.playing ? _player.pause() : _player.play());
                }
              : null,
          icon: (_player.playing)
              ? const Icon(Icons.pause_rounded)
              : const Icon(Icons.play_arrow_rounded),
          iconSize: 32,
        );
      },
    );
  }

  Widget _progressSlider() {
    return StreamBuilder(
      stream: StreamGroup.merge([
        _player.durationStream,
        _player.positionStream,
        _player.bufferedPositionStream,
      ]),
      builder: (context, _) {
        if (_player.duration == null) return const SizedBox.shrink();
        return Slider(
          max: _player.duration!.inMilliseconds.toDouble(),
          value: _player.position.inMilliseconds.toDouble(),
          secondaryTrackValue: _player.bufferedPosition.inMilliseconds
              .toDouble(),
          onChanged: (value) async {
            await _player.seek(Duration(milliseconds: value.toInt()));
          },
          onChangeStart: (_) async {
            _shouldContinue = _player.playing;
            await _player.pause();
          },
          onChangeEnd: (_) async {
            if (_shouldContinue) {
              await _player.play();
            }
          },
        );
      },
    );
  }
}
