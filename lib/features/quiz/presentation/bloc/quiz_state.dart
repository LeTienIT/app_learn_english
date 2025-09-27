// STATES
import '../../domain/entities/quiz_question.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

class QuizInProgress extends QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final int remainingSeconds;
  final List<int> results; // -1 unknown, 0 incorrect, 1 correct
  final bool showFeedback;
  final bool? lastAnswerCorrect;
  final String? lastGivenAnswer;

  QuizInProgress({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.remainingSeconds,
    required this.results,
    this.showFeedback = false,
    this.lastAnswerCorrect,
    this.lastGivenAnswer,
  });
  QuizInProgress copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    int? remainingSeconds,
    List<int>? results,
    bool? showFeedback,
    bool? lastAnswerCorrect,
    String? lastGivenAnswer,
  }) {
    return QuizInProgress(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      results: results ?? this.results,
      showFeedback: showFeedback ?? this.showFeedback,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      lastGivenAnswer: lastGivenAnswer ?? this.lastGivenAnswer,
    );
  }
}

class QuizNext extends QuizState {}

class QuizFinished extends QuizState {
  final int score;
  final int total;
  final List<int> results;
  QuizFinished({required this.score, required this.total, required this.results});
}