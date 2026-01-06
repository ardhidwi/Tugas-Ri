import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> putarLagu(String fileName) async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print("Error Audio: $e");
    }
  }

  static Future<void> stopLagu() async {
    await _player.stop();
  }
}
