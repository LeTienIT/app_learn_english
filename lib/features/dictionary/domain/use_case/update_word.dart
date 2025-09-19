import '../entities/word.dart';
import '../repositories/word_repository.dart';

class UpdateWord {
  final WordRepository repository;

  UpdateWord(this.repository);

  Future<void> call(Word word) async {
    return repository.updateWord(word);
  }
}
