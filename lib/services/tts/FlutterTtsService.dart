import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsService {
  final FlutterTts _tts = FlutterTts();

  FlutterTtsService() {
    _tts.setLanguage("en-US");
    _tts.setPitch(1.0);
    _tts.setSpeechRate(0.2);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
