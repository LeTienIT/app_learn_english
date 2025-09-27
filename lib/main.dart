import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learn_english/features/dictionary/data/models/word_data.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_bloc.dart';
import 'package:learn_english/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:learn_english/features/quiz/presentation/screens/exercise_screen.dart';
import 'package:learn_english/features/quiz/presentation/screens/quiz_screen.dart';
import 'features/dictionary/domain/use_case/add_word.dart';
import 'features/dictionary/domain/use_case/delete_word.dart';
import 'features/dictionary/domain/use_case/get_all_word.dart';
import 'features/dictionary/domain/use_case/update_word.dart';
import 'features/dictionary/presentation/bloc/word_bloc.dart';
import 'features/dictionary/presentation/bloc/word_event.dart';
import 'features/dictionary/presentation/screens/dictionaryScreen.dart';
import 'features/object_detection/presentation/bloc/object_detection_bloc.dart';
import 'features/object_detection/presentation/screens/CameraScreen.dart';
import 'injection/injection.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordDataAdapter());

  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ObjectDetectionBloc>()),
        BlocProvider(create: (_) => di.sl<ImageTranslationBloc>()),
        BlocProvider(create: (_) => WordBloc(
          addWord: di.sl<AddWord>(),
          getAllWords: di.sl<GetAllWords>(),
          updateWord: di.sl<UpdateWord>(),
          deleteWord: di.sl<DeleteWord>(),
        )..add(LoadWords())),
        BlocProvider(create: (_) => di.sl<QuizBloc>()),

      ],
      child: MaterialApp(
        initialRoute: '/imageObject',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/imageObject':
              return MaterialPageRoute(
                builder: (_) => const ObjectDetectionPage(),
              );
            case '/dictionary':
              return MaterialPageRoute(
                builder: (_) => const DictionaryView(),
              );
            case '/quiz':
              return MaterialPageRoute(
                builder: (_) => const QuizScreen(),
              );
            case '/excercise':
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (_) => ExerciseScreen(
                  numberQ: args?['numberQ'] ?? 10,
                  typeQ: args?['typeQ'] ?? "all",
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const ObjectDetectionPage(), // fallback nếu route sai
              );
          }
        },
        home: const ObjectDetectionPage(),
      ),
    ),
  );
}