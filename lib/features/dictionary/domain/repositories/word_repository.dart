import '../entities/word.dart';

abstract class WordRepository {
  Future<int> addWord(Word word);
  Future<List<Word>> getAllWords({String? languageType});
  Future<void> updateWord(Word word);
  Future<void> deleteWord(Word word);
}