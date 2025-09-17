abstract class ObjectDetectionState {}

class ObjectDetectionInitial extends ObjectDetectionState {}

class ObjectDetectionLoading extends ObjectDetectionState {}

class ObjectDetectionSuccess extends ObjectDetectionState {
  final List<String> labels; 
  ObjectDetectionSuccess(this.labels);
}

class ObjectDetectionFailure extends ObjectDetectionState {
  final String message;
  ObjectDetectionFailure(this.message);
}