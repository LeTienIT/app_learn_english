import '../entities/quiz_question.dart';

abstract class QuizRepository {
  Future<List<QuizQuestion>> generateQuiz({
    int numberOfQuestions = 10,
    String typeQ = "all"
  });
}