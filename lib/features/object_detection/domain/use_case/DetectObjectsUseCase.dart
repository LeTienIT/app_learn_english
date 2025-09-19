import 'dart:io';

import '../entities/DetectedLabel.dart';
import '../repository/ObjectDetectionRepository.dart';

class DetectObjectsUseCase {
  final ObjectDetectionRepository repository;

  DetectObjectsUseCase(this.repository);

  Future<List<DetectedLabel>> call(File imagePath) {
    return repository.detectObjects(imagePath);
  }
}