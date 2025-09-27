import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:learn_english/features/quiz/presentation/bloc/quiz_state.dart';

import '../../../../injection/injection.dart' as di;
import '../../../../services/speech_to_text/SpeechService.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/use_case/generate_use_case.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GenerateQuiz generateQuiz;
  Timer? _timer;
  int _timePerQuestion = 30;

  List<QuizQuestion> _questions = [];
  List<int> _results = [];
  int _currentIndex = 0;
  int _score = 0;
  int _remainingSeconds = 0;

  QuizBloc({required this.generateQuiz}) : super(QuizInitial()) {
    on<StartQuiz>(_onStartQuiz);
    on<QuizTick>(_onTick);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<ResetQuiz>(_onResetQuiz);
  }

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final qs = await generateQuiz.call(numberOfQuestions: event.numberOfQuestions, typeQ: event.typeQ);
      if (qs.isEmpty) {
        emit(QuizError('Không có từ nào trong danh sách'));
        return;
      }

      _questions = qs;
      _results = List<int>.filled(_questions.length, -1);
      _currentIndex = 0;
      _score = 0;
      _timePerQuestion = event.timePerQuestion;
      _remainingSeconds = _timePerQuestion;

      _startTimer();
      emit(
          QuizInProgress(
            questions: _questions,
            currentIndex: _currentIndex,
            score: _score,
            remainingSeconds: _remainingSeconds,
            results: List<int>.from(_results),
            showFeedback: false,
          )
      );
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(QuizTick());
    });
  }

  void _onTick(QuizTick event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    _remainingSeconds--;
    if (_remainingSeconds <= 0) {
      _markAnswer(false, givenAnswer: null);
      _goNext(emit);
      return;
    }
    emit((state as QuizInProgress).copyWith(
      questions: _questions,
      currentIndex: _currentIndex,
      score: _score,
      remainingSeconds: _remainingSeconds,
      results: List<int>.from(_results),
    ));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    final quizState = state as QuizInProgress;
    if (quizState.lastAnswerCorrect == true) {
      return;
    }
    final q = _questions[_currentIndex];
    final isCorrect = _evaluateAnswer(q, event.answer);

    if (isCorrect) {
      _timer?.cancel();
      _markAnswer(true, givenAnswer: event.answer);

      emit((state as QuizInProgress).copyWith(
        questions: _questions,
        currentIndex: _currentIndex,
        score: _score,
        remainingSeconds: _remainingSeconds,
        results: List<int>.from(_results),
        showFeedback: true,
        lastAnswerCorrect: true,
        lastGivenAnswer: event.answer,
      ));

      Future.delayed(const Duration(milliseconds: 1000), () {
        add(NextQuestion());
      });
    } else {
      emit((state as QuizInProgress).copyWith(
        showFeedback: true,
        lastAnswerCorrect: false,
        lastGivenAnswer: event.answer,
      ));
      // timer vẫn chạy, user có thể thử tiếp
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) async {
    _goNext(emit);
  }

  void _goNext(Emitter<QuizState> emit) {
    if (_currentIndex >= _questions.length - 1) {
      _timer?.cancel();
      emit(QuizFinished(score: _score, total: _questions.length, results: List<int>.from(_results)));
      return;
    }
    _currentIndex++;
    _remainingSeconds = _timePerQuestion;
    _startTimer();
    emit(QuizInProgress(
      questions: _questions,
      currentIndex: _currentIndex,
      score: _score,
      remainingSeconds: _remainingSeconds,
      results: List<int>.from(_results),
      showFeedback: false,
    ));
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    _timer?.cancel();
    di.sl<SpeechToTextService>().stopListening();
    _questions = [];
    _results = [];
    _score = 0;
    _currentIndex = 0;
    emit(QuizInitial());
  }

  void _markAnswer(bool correct, {String? givenAnswer}) {
    _results[_currentIndex] = correct ? 1 : 0;
    if (correct) _score++;
  }

  bool _evaluateAnswer(QuizQuestion q, String given) {
    final type = q.type;
    final word = q.word;
    final cleanedGiven = _normalize(given); // bỏ dấu, lowercase

    if (type == QuizType.viToEn) {
      return _isSimilar(cleanedGiven, _normalize(word.english));
    } else if (type == QuizType.enToVi) {
      final candidates = word.vietnamese.split(RegExp(r'[;,]'))
          .map((s) => _normalize(s))
          .toList();
      for (final c in candidates) {
        if (_isSimilar(cleanedGiven, c)) return true;
      }
      return false;
    } else { // enSpeaking
      final target = _normalize(word.english);

      // tách từng từ trong chuỗi nói của user
      final words = cleanedGiven.split(RegExp(r'\s+'));

      // check nếu bất kỳ từ nào match target
      for (final w in words) {
        if (_isSimilar(w, target)) return true;
      }
      return false;
    }
  }


  String _normalize(String s) {
    var r = s.toLowerCase().trim();
    r = r.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '');
    r = r.replaceAll(RegExp(r'\s+'), ' ');
    return r;
  }

  bool _isSimilar(String a, String b) {
    if (a == b) return true;
    final dist = _levenshtein(a, b);
    final len = max(a.length, b.length);
    if (len == 0) return true;
    final similarity = 1 - dist / len;
    // threshold: >= 0.8 similarity OR edit distance <=1
    return similarity >= 0.8 || dist <= 1;
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    final v0 = List<int>.filled(t.length + 1, 0);
    final v1 = List<int>.filled(t.length + 1, 0);
    for (var i = 0; i <= t.length; i++) {
      v0[i] = i;
    }
    for (var i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (var j = 0; j < t.length; j++) {
        final cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(min(v1[j] + 1, v0[j + 1] + 1), v0[j] + cost);
      }
      for (var j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}