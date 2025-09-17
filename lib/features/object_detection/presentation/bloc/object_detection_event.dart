import 'dart:io';

abstract class ObjectDetectionEvent {}

/// Sự kiện detect object từ ảnh
class DetectObjectsEvent extends ObjectDetectionEvent {
  final File imagePath;

  DetectObjectsEvent(this.imagePath);
}