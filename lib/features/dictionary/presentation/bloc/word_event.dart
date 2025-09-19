import '../../domain/entities/word.dart';

abstract class WordEvent{}

class LoadWords extends WordEvent {}

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