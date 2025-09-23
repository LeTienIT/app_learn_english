import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();
  
  bool _available = true;

  bool get available => _available;

  Future<void> init() async {
    try {
      _available = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint("Speech status: $status");
        },
        onError: (error) {
          debugPrint("Speech error: $error");
          _available = false; // không hỗ trợ
        },
      );
    } catch (e) {
      debugPrint("Speech init exception: $e");
      _available = false;
    }
  }

  Future<void> startListening({required Function(String text) onResult, bool partialResults = true,}) async {
    if (!_available) return;

    await _speechToText.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
}