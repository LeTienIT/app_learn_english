import '../../domain/entities/word.dart';

abstract class WordState{}

class WordInitial extends WordState {}

class WordLoading extends WordState {}

class WordLoaded extends WordState {
  final List<Word> words;
  WordLoaded(this.words);
}

class WordAddSuccess extends WordState {
  final Word word;
  WordAddSuccess(this.word);
}

class WordError extends WordState {
  final String message;
  WordError(this.message);
}