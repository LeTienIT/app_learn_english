import '../../../dictionary/domain/entities/word.dart';

enum QuizType { viToEn, enToVi, enSpeaking }

class QuizQuestion {
  final Word word;
  final QuizType type;

  QuizQuestion({required this.word, required this.type});
}