import 'dart:io';

import '../entity/DetectedLabel.dart';

abstract class ObjectDetectionRepository {
  Future<List<DetectedLabel>> detectObjects(File imagePath);
}