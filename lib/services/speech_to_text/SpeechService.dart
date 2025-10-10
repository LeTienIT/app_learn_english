import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();

  bool _available = true;

  bool get available => _available;
  final ValueNotifier<bool> isMicActive = ValueNotifier(false);

  Future<void> init() async {
    try {
      _available = await _speechToText.initialize(
        onStatus: (status) {
          // debugPrint("Speech status: $status");
          if (status == "done" || status == "notListening") {
            isMicActive.value = false;
            _speechToText.cancel();
          }
          else if (status == "listening") {
            isMicActive.value = true;
          }
        },
        onError: (error) {
          debugPrint("Speech error: $error");
          _speechToText.cancel();
        },
      );
    } catch (e) {
      debugPrint("Speech init exception: $e");
      _available = false;
    }
  }

  Future<void> startListening({required Function(String text) onResult, bool partialResults = true, required String languageCode,}) async {
    if (!_available) return;

    final locales = await _speechToText.locales();

    // ánh xạ từ languageCode -> localeId phù hợp trong danh sách hệ thống
    final locale = locales.firstWhere(
          (l) =>
      l.localeId.toLowerCase().startsWith(languageCode.toLowerCase()) ||
          l.name.toLowerCase().contains(languageCode.toLowerCase()),
      orElse: () => locales.first, // fallback
    );

    await _speechToText.listen(
      localeId: locale.localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: partialResults,
      ),
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    } else {
      await _speechToText.cancel();
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
}