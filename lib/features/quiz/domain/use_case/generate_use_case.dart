import '../entities/quiz_question.dart';
import '../repositories/quiz_repository.dart';

class GenerateQuiz {
  final QuizRepository repository;

  GenerateQuiz(this.repository);

  Future<List<QuizQuestion>> call({int numberOfQuestions = 10, String typeQ = "all"}) {
    return repository.generateQuiz(numberOfQuestions: numberOfQuestions, typeQ: typeQ);
  }
}