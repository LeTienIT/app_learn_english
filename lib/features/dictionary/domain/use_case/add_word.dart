import '../entities/word.dart';
import '../repositories/word_repository.dart';

class AddWord {
  final WordRepository repository;

  AddWord(this.repository);

  Future<int> call(Word word) async {
    return repository.addWord(word);
  }
}