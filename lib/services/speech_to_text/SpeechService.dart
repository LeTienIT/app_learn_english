import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();
  
  bool _available = true;
  
  Future<void> init() async{
    _available = await _speechToText.initialize(
      onStatus: (status) {
      },
      onError: (error) {
        throw("Speech error: $error");
      },
    );
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