import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/DetectedLabel.dart';
import '../../domain/use_case/DetectObjectsUseCase.dart';
import 'object_detection_event.dart';
import 'object_detection_state.dart';

class ObjectDetectionBloc extends Bloc<ObjectDetectionEvent, ObjectDetectionState> {
  final DetectObjectsUseCase detectObjectsUseCase;

  ObjectDetectionBloc(this.detectObjectsUseCase) : super(ObjectDetectionInitial()) {
    on<DetectObjectsEvent>(_onDetectObjects);
  }

  Future<void> _onDetectObjects(
      DetectObjectsEvent event,
      Emitter<ObjectDetectionState> emit,
      ) async {
    emit(ObjectDetectionLoading());
    try {
      final List<DetectedLabel> results =
      await detectObjectsUseCase(event.imagePath);

      // không cần map sang string nữa
      emit(ObjectDetectionSuccess(results));
    } catch (e) {
      emit(ObjectDetectionFailure(e.toString()));
    }
  }
}
