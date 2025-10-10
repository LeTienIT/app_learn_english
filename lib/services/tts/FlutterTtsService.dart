import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsService {
  final FlutterTts _tts = FlutterTts();
  String _currentLang = "en-US";

  FlutterTtsService() {
    _setup();
  }

  Future<void> _setup() async {
    await _tts.setLanguage(_currentLang);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.3);
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLang = languageCode;
    await _tts.setLanguage(languageCode);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}

