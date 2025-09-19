import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/repository/TextToSpeechRepository.dart';

class FlutterTtsService implements TextToSpeechRepository {
  final FlutterTts _tts = FlutterTts();

  FlutterTtsService() {
    _tts.setLanguage("en-US");
    _tts.setPitch(1.0);
    _tts.setSpeechRate(0.3);
  }

  @override
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
