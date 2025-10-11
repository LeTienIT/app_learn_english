import '../entities/word.dart';
import '../repositories/word_repository.dart';

class GetAllWords {
  final WordRepository repository;

  GetAllWords(this.repository);

  Future<List<Word>> call({String? languageType}) async {
    return repository.getAllWords(languageType: languageType);
  }
}
