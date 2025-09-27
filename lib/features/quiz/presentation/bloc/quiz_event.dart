// EVENTS
abstract class QuizEvent {}

class StartQuiz extends QuizEvent {
  final int numberOfQuestions;
  final int timePerQuestion;
  final String typeQ;
  StartQuiz({this.numberOfQuestions = 10, this.timePerQuestion = 30, this.typeQ = "all"});
}

class SubmitAnswer extends QuizEvent {
  final String answer;
  SubmitAnswer(this.answer);
}

class QuizTick extends QuizEvent {}

class NextQuestion extends QuizEvent {}

class ResetQuiz extends QuizEvent {}