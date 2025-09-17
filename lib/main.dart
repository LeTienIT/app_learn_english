import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/object_detection/data/data_source/mlkit_object_detection_datasource.dart';
import 'features/object_detection/data/repository/object_detection_repository_impl.dart';
import 'features/object_detection/domain/use_case/DetectObjectsUseCase.dart';
import 'features/object_detection/presentation/bloc/object_detection_bloc.dart';
import 'features/object_detection/presentation/screens/CameraScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final datasource = MlkitObjectDetectionDatasource();
  await datasource.init();
  final repository = ObjectDetectionRepositoryImpl(datasource);
  final usecase = DetectObjectsUseCase(repository);

  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => ObjectDetectionBloc(usecase),
        child: const ObjectDetectionPage(),
      ),
    ),
  );
}