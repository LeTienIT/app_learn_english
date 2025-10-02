import 'package:audioplayers/audioplayers.dart';

import '../../core/constants.dart';
import '../../injection/injection.dart' as di;
import '../app_storage/share_preferences.dart';

class AudioPlayerService {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  Future<void> playBackground() async {
    final checkMusic = await di.sl<AppStorageService>().get(musicKey);
    if(checkMusic){
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setSource(AssetSource("music/background.mp3"));
      await _bgmPlayer.resume();
    }
  }

  Future<void> stopBackground() async {
    print("stop music");
    await _bgmPlayer.stop();
    await _bgmPlayer.release();
  }

  Future<void> playCorrect() async {
    await _effectPlayer.play(AssetSource("music/ting.mp3"));
  }

  Future<void> playWrong() async {
    await _effectPlayer.play(AssetSource("music/wrong.mp3"));
  }

  Future<void> playFinished() async {
    await _effectPlayer.play(AssetSource("music/complete.mp3"));
  }

}
