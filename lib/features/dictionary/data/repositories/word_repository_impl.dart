import '../../domain/entities/word.dart';
import '../../domain/repositories/word_repository.dart';
import '../datasources/word_data_source.dart';
import '../models/word_data.dart';

class WordRepositoryImpl implements WordRepository {
  final WordLocalDataSource localDataSource;
  WordRepositoryImpl(this.localDataSource);

  @override
  Future<int> addWord(Word word) async {
    final list = await localDataSource.getAllWords();
    final exists = list.any((w) => w.english.toLowerCase() == word.english.toLowerCase());
    if (exists) {
      return -1;
    }
    final wordData = WordData(
      english: word.english,
      vietnamese: word.vietnamese,
      example: word.example,
      favorite: word.favorite,
    );

    final key = await localDataSource.addWord(wordData);
    return key;
  }

  @override
  Future<List<Word>> getAllWords() async {
    final list = await localDataSource.getAllWords();
    return list.map((data) => Word(
      id: data.key as int?,
      english: data.english,
      vietnamese: data.vietnamese,
      example: data.example,
      favorite: data.favorite,
    )).toList();
  }

  @override
  Future<void> updateWord(Word word) async {
    if (word.id == null) {
      throw Exception("Word id is null, cannot update");
    }

    final wordData = WordData(
      english: word.english,
      vietnamese: word.vietnamese,
      example: word.example,
      favorite: word.favorite,
    );

    await localDataSource.updateWord(word.id!, wordData);
  }

  @override
  Future<void> deleteWord(Word word) async {
    if (word.id == null) {
      throw Exception("Word id is null, cannot update");
    }
    await localDataSource.deleteWord(word.id!);
  }
}
