import 'dart:io';

import '../entities/DetectedLabel.dart';

abstract class ObjectDetectionRepository {
  Future<List<DetectedLabel>> detectObjects(File imagePath);
}