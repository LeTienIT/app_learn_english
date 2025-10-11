import 'dart:math';

import '../../../../injection/injection.dart' as di;
import '../../../dictionary/domain/entities/word.dart';
import '../../../dictionary/domain/use_case/get_all_word.dart';
import '../../../setting/presentation/bloc/setting_bloc.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final GetAllWords getAllWords;
  final Random _random = Random();

  QuizRepositoryImpl(this.getAllWords);

  @override
  Future<List<QuizQuestion>> generateQuiz({int numberOfQuestions = 10, String typeQ = "all"}) async {
    final settings = di.sl<SettingsBloc>().state;
    final listWord = await getAllWords.call(languageType: settings.languageCode);
    listWord.shuffle();
    final selected = listWord.take(numberOfQuestions).toList();
    return selected.map((word) {
      QuizType type = QuizType.enToVi;
      if(typeQ == "all") {
        type = QuizType.values[_random.nextInt(QuizType.values.length)];
      }
      else if(typeQ == "voice"){
        type = QuizType.enSpeaking;
      }
      else{
        final normalTypes = [QuizType.viToEn, QuizType.enToVi];
        type = normalTypes[_random.nextInt(normalTypes.length)];
      }
      return QuizQuestion(word: word, type: type);
    }).toList();
  }
}