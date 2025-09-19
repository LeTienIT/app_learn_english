abstract class TextToSpeechRepository {
  Future<void> speak(String text);
  Future<void> stop();
}
