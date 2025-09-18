import 'package:get_it/get_it.dart';
import 'package:learn_english/features/object_detection/domain/repository/ObjectDetectionRepository.dart';

import '../features/object_detection/data/data_source/image_text_datasource.dart';
import '../features/object_detection/data/data_source/image_text_datasource_impl.dart';
import '../features/object_detection/data/data_source/mlkit_object_detection_datasource.dart';
import '../features/object_detection/data/repository/image_text_datasource_impl.dart';
import '../features/object_detection/data/repository/object_detection_repository_impl.dart';
import '../features/object_detection/domain/repository/ImageTextRepository.dart';
import '../features/object_detection/domain/use_case/DetectObjectsUseCase.dart';
import '../features/object_detection/domain/use_case/TranslateUseCase.dart';
import '../features/object_detection/presentation/bloc/image_translation_bloc.dart';
import '../features/object_detection/presentation/bloc/object_detection_bloc.dart';

final sl = GetIt.instance;

void init() {
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

}