import '../../domain/entities/word.dart';

abstract class WordEvent{}

class LoadWords extends WordEvent {
  final String? languageType;
  LoadWords({this.languageType});
}

class AddWordEvent extends WordEvent {
  final Word word;
  AddWordEvent(this.word);
}

class UpdateWordEvent extends WordEvent {
  final Word word;
  UpdateWordEvent(this.word);
}

class DeleteWordEvent extends WordEvent {
  final Word word;
  DeleteWordEvent(this.word);
}