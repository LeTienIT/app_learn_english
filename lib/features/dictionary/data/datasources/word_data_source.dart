import 'package:hive/hive.dart';
import '../models/word_data.dart';

abstract class WordLocalDataSource {
  Future<int> addWord(WordData word);
  Future<List<WordData>> getAllWords();
  Future<void> updateWord(WordData word);
  Future<void> deleteWord(WordData word);
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
  Future<void> updateWord(WordData word) async {
    await word.save(); // vì WordData extends HiveObject
  }

  @override
  Future<void> deleteWord(WordData word) async {
    await word.delete();
  }
}
