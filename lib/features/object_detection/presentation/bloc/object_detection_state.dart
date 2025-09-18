import '../../domain/entity/DetectedLabel.dart';

abstract class ObjectDetectionState {}

class ObjectDetectionInitial extends ObjectDetectionState {}

class ObjectDetectionLoading extends ObjectDetectionState {}

class ObjectDetectionSuccess extends ObjectDetectionState {
  final List<DetectedLabel> labels;
  ObjectDetectionSuccess(this.labels);
}

class ObjectDetectionFailure extends ObjectDetectionState {
  final String message;
  ObjectDetectionFailure(this.message);
}