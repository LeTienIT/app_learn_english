import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:learn_english/features/object_detection/domain/repository/ObjectDetectionRepository.dart';
import '../features/dictionary/data/datasources/word_data_source.dart';
import '../features/dictionary/data/models/word_data.dart';
import '../features/dictionary/data/repositories/word_repository_impl.dart';
import '../features/dictionary/domain/repositories/word_repository.dart';
import '../features/dictionary/domain/use_case/add_word.dart';
import '../features/dictionary/domain/use_case/delete_word.dart';
import '../features/dictionary/domain/use_case/get_all_word.dart';
import '../features/dictionary/domain/use_case/update_word.dart';
import '../features/object_detection/data/data_source/image_text_datasource.dart';
import '../features/object_detection/data/data_source/image_text_datasource_impl.dart';
import '../features/object_detection/data/data_source/mlkit_object_detection_datasource.dart';
import '../features/object_detection/data/repository/FlutterTtsService.dart';
import '../features/object_detection/data/repository/ImageService.dart';
import '../features/object_detection/data/repository/image_text_datasource_impl.dart';
import '../features/object_detection/data/repository/object_detection_repository_impl.dart';
import '../features/object_detection/domain/repository/ImageRepository.dart';
import '../features/object_detection/domain/repository/ImageTextRepository.dart';
import '../features/object_detection/domain/repository/TextToSpeechRepository.dart';
import '../features/object_detection/domain/use_case/DetectObjectsUseCase.dart';
import '../features/object_detection/domain/use_case/PickAndCropImageUseCase.dart';
import '../features/object_detection/domain/use_case/TextToSpeechUseCase.dart';
import '../features/object_detection/domain/use_case/TranslateUseCase.dart';
import '../features/object_detection/presentation/bloc/image_translation_bloc.dart';
import '../features/object_detection/presentation/bloc/object_detection_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ImageRepository>(() => ImageService());
  sl.registerLazySingleton<PickAndCropImageUseCase>(
        () => PickAndCropImageUseCase(sl()),
  );

  // BLoC
  sl.registerFactory(() => ImageTranslationBloc(sl()));

  // UseCase
  sl.registerLazySingleton(() => ProcessImageAndTranslateUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ImageTextRepository>(
        () => ImageTextRepositoryImpl(sl()),
  );

  // DataSource
  sl.registerLazySingleton<ImageTextDataSource>(
        () => ImageTextDataSourceImpl(),
  );

  // BLoC
  sl.registerFactory(() => ObjectDetectionBloc(sl()));

  // UseCase
  sl.registerLazySingleton(() => DetectObjectsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ObjectDetectionRepository>(
        () => ObjectDetectionRepositoryImpl(sl()),
  );

  // DataSource
  sl.registerLazySingleton(
        () => MlkitObjectDetectionDatasource(),
  );

  sl.registerLazySingleton<TextToSpeechUseCase>(
      () => TextToSpeechUseCase(sl()),
  );

  sl.registerLazySingleton<TextToSpeechRepository>(
      () => FlutterTtsService(),
  );

  // 1. Open Hive box
  final box = await Hive.openBox<WordData>('words');

  // 2. DataSource
  sl.registerLazySingleton<WordLocalDataSource>(
        () => WordLocalDataSourceImpl(box),
  );

  // 3. Repository
  sl.registerLazySingleton<WordRepository>(
        () => WordRepositoryImpl(sl()),
  );

  // 4. UseCases
  sl.registerLazySingleton(() => AddWord(sl()));
  sl.registerLazySingleton(() => GetAllWords(sl()));
  sl.registerLazySingleton(() => UpdateWord(sl()));
  sl.registerLazySingleton(() => DeleteWord(sl()));
}