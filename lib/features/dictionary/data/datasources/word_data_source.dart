import 'package:hive/hive.dart';
import '../models/word_data.dart';

abstract class WordLocalDataSource {
  Future<int> addWord(WordData word);
  Future<List<WordData>> getAllWords();
  Future<void> updateWord(int key, WordData word);
  Future<void> deleteWord(int key);
}

class WordLocalDataSourceImpl implements WordLocalDataSource {
  final Box<WordData> box;

  WordLocalDataSourceImpl(this.box);

  @override
  Future<int> addWord(WordData word) async {
    return await box.add(word);
  }

  @override
  Future<List<WordData>> getAllWords() async {
    return box.values.toList();
  }

  @override
  Future<void> updateWord(int key, WordData word) async {
    await box.put(key, word);
  }

  @override
  Future<void> deleteWord(int key) async {
    await box.delete(key);
  }
}
