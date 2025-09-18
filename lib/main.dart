import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_bloc.dart';
import 'features/object_detection/presentation/bloc/object_detection_bloc.dart';
import 'features/object_detection/presentation/screens/CameraScreen.dart';
import 'injection/injection.dart' as di;

void main() async{
  di.init();

  runApp(
    MaterialApp(
      home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<ObjectDetectionBloc>()),
            BlocProvider(create: (_) => di.sl<ImageTranslationBloc>())
          ],
          child: ObjectDetectionPage()
      )
    ),
  );
}