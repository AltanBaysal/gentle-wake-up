import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gentle_wake_up/services/audio_handler.dart';

// The callback must be a top-level function
@pragma('vm:entry-point')
void alarmCallback() async {
  // Initialize the audio service in the background isolate
  await AudioPlayerHandler.init();
  final audioHandler = AudioPlayerHandler.instance;

  await audioHandler.prepareAlarmMusic();
  await audioHandler.play();

  // Stop after 30 minutes
  Timer(const Duration(minutes: 30), () async {
    await audioHandler.stop();
  });
}
