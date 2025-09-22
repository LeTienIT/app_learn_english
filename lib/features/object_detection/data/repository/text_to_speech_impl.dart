import '../../../../services/tts/FlutterTtsService.dart';
import '../../domain/repository/TextToSpeechRepository.dart';

class TextToSpeechImpl implements TextToSpeechRepository {
  final FlutterTtsService ttsService;

  const TextToSpeechImpl(this.ttsService);

  @override
  Future<void> speak(String text) async{
    await ttsService.speak(text);
  }

  @override
  Future<void> stop() async{
    ttsService.stop();
  }

}