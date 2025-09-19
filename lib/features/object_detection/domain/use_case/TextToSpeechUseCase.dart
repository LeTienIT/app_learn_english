import '../repository/TextToSpeechRepository.dart';

class TextToSpeechUseCase{
  final TextToSpeechRepository repository;

  TextToSpeechUseCase(this.repository);

  Future<void> call(String text) => repository.speak(text);
}