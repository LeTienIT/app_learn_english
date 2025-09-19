import 'dart:io';

import '../../domain/entities/DetectedLabel.dart';
import '../../domain/repository/ObjectDetectionRepository.dart';
import '../data_source/mlkit_object_detection_datasource.dart';

class ObjectDetectionRepositoryImpl implements ObjectDetectionRepository {
  final MlkitObjectDetectionDatasource datasource;

  ObjectDetectionRepositoryImpl(this.datasource);

  @override
  Future<List<DetectedLabel>> detectObjects(File imagePath) {
    return datasource.detectObjects(imagePath);
  }
}
