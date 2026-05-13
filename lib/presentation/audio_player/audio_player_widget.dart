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
  bool _loadError = false;

  /// Used to store the playback status of the player before seeking starts,
  /// so we can restart playback if necessary
  bool _shouldContinue = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.processingStateStream.listen((
      state,
    ) async {
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
    if (mounted) setState(() => _loadError = false);
    await _player.stop();
    try {
      final file = await widget.cacheManager.getSingleFile(widget.url);
      await _player.setAudioSource(AudioSource.file(file.path));
    } on PlayerException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 10),
          content: Text(
            'Sorry — something went wrong loading the learning track.\n'
            'This often resolves itself after a while, so please try '
            'again another time, or try a different tag/track.',
          ),
        ),
      );
    } on Exception {
      if (mounted) setState(() => _loadError = true);
    }
  }

  @override
  void dispose() {
    unawaited(_completionSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadError) {
      return Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            'Unavailable offline',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
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
        if (_player.duration == null) {
          return const Padding(
            padding: .symmetric(horizontal: 8),
            child: LinearProgressIndicator(),
          );
        }
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
