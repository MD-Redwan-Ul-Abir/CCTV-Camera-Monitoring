import 'package:audioplayers/audioplayers.dart';

import '../utils/notificationAudio.dart';
class SoundPlay{
  final _player = AudioPlayer();

  void playSound() async {
    await _player.play(AssetSource(NotificationAudio.notificationAudio1));
  }
}