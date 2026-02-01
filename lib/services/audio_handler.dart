import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  // Singleton instance
  static AudioPlayerHandler? _instance;

  static AudioPlayerHandler get instance {
    if (_instance == null) {
      throw Exception('AudioPlayerHandler not initialized');
    }
    return _instance!;
  }

  static Future<void> init() async {
    _instance = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.gentle_wake_up.channel.audio',
        androidNotificationChannelName: 'Alarm Background Music',
        androidNotificationOngoing: true,
      ),
    );
  }

  AudioPlayerHandler() {
    _player.playbackEventStream.listen(_broadcastState);
  }

  Future<void> prepareAlarmMusic() async {
    // Assuming the file is in assets
    try {
        await _player.setAsset('assets/sounds/alarm_music.mp3');
        await _player.setLoopMode(LoopMode.one);
    } catch (e) {
        print("Error loading audio asset: $e");
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));

    // Update media item to show in notification
    mediaItem.add(const MediaItem(
      id: 'alarm_music',
      album: 'Gentle Wake Up',
      title: 'Morning Alarm',
      artist: 'Gentle Wake Up App',
      duration: null,
      artUri: null,
    ));
  }
}
