import 'package:just_audio/just_audio.dart';

class Sounds {
  static void successSound() async {
    final player = AudioPlayer();
    try {
      await player.setAsset('assets/sounds/success.mp3');
      await player.setVolume(0.5);
      await player.play();
      await Future.delayed(const Duration(milliseconds: 500), () async {
        await player.stop();
      });
    } finally {
      await player.dispose();
    }
  }
}
