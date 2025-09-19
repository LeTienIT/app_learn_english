import '../entities/word.dart';

abstract class WordRepository {
  Future<int> addWord(Word word);
  Future<List<Word>> getAllWords();
  Future<void> updateWord(Word word);
  Future<void> deleteWord(Word word);
}