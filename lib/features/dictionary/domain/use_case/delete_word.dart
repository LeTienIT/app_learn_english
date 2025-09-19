import '../entities/word.dart';
import '../repositories/word_repository.dart';

class DeleteWord {
  final WordRepository repository;

  DeleteWord(this.repository);

  Future<void> call(Word word) async {
    return repository.deleteWord(word);
  }
}
